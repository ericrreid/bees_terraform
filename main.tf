provider "mongodbatlas" {
  public_key  = var.atlas_access.public_key
  private_key = var.atlas_access.private_key
}

resource "mongodbatlas_project" "our_project" {
  name = var.our_project.name
  org_id = var.our_project.org_id
}

resource "mongodbatlas_cluster" "source_cluster" {
  depends_on = [
    mongodbatlas_project.our_project
  ]
  # These uniquely identify the existing cluster (it gets created otherwise)
  project_id = mongodbatlas_project.our_project.id
  name = var.source_cluster.name
  provider_name = var.source_cluster.provider_name
  provider_instance_size_name = var.source_cluster.provider_instance_size_name
  cluster_type = var.source_cluster.cluster_type
  mongo_db_major_version = var.source_cluster.mongodb_major_version
  replication_specs { 
    num_shards = var.source_cluster.replication_specs.num_shards
    regions_config {
      region_name=var.source_cluster.replication_specs.regions_config.region_name
      electable_nodes=var.source_cluster.replication_specs.regions_config.electable_nodes
      priority=var.source_cluster.replication_specs.regions_config.priority
      read_only_nodes=var.source_cluster.replication_specs.regions_config.read_only_nodes
    }
  } 
  cloud_backup = var.source_cluster.cloud_backup # Set if not yet set
}

resource "mongodbatlas_cluster" "target_cluster" {
  depends_on = [
    mongodbatlas_project.our_project
  ]
  project_id = mongodbatlas_project.our_project.id
  name = var.target_cluster.name
  provider_name = var.target_cluster.provider_name
  provider_instance_size_name = var.target_cluster.provider_instance_size_name
  cluster_type = var.target_cluster.cluster_type
  mongo_db_major_version = var.target_cluster.mongodb_major_version
  replication_specs { 
    num_shards = var.target_cluster.replication_specs.num_shards
    regions_config {
      region_name=var.target_cluster.replication_specs.regions_config.region_name
      electable_nodes=var.target_cluster.replication_specs.regions_config.electable_nodes
      priority=var.target_cluster.replication_specs.regions_config.priority
      read_only_nodes=var.target_cluster.replication_specs.regions_config.read_only_nodes
    }
  } 
  cloud_backup = var.target_cluster.cloud_backup # Set if not yet set
}

resource "mongodbatlas_cloud_backup_schedule" "backup_schedule" {
  depends_on = [
    mongodbatlas_cluster.source_cluster
  ]
  project_id   = mongodbatlas_project.our_project.id
  cluster_name = mongodbatlas_cluster.source_cluster.name

  # Example using current schedule of the BEES-PROD-US/BERLINER-PROD/berliner Cluster
  reference_hour_of_day    = var.backup_schedule.reference_hour_of_day
  reference_minute_of_hour = var.backup_schedule.reference_minute_of_hour
  restore_window_days      = var.backup_schedule.restore_window_days

  policy_item_hourly {
    frequency_interval = var.backup_schedule.policy_item_hourly.frequency_interval
    retention_unit = var.backup_schedule.policy_item_hourly.retention_unit
    retention_value = var.backup_schedule.policy_item_hourly.retention_value
  }
#  policy_item_daily = var.backup_schedule.policy_item_daily 

  policy_item_weekly {
    frequency_interval = var.backup_schedule.policy_item_weekly.frequency_interval
    retention_unit = var.backup_schedule.policy_item_weekly.retention_unit
    retention_value = var.backup_schedule.policy_item_weekly.retention_value
  }

  policy_item_monthly {
    frequency_interval = var.backup_schedule.policy_item_monthly.frequency_interval
    retention_unit = var.backup_schedule.policy_item_monthly.retention_unit
    retention_value = var.backup_schedule.policy_item_monthly.retention_value
  }
}

resource "mongodbatlas_cloud_backup_snapshot" "snapshot" {
    depends_on = [
      mongodbatlas_cluster.source_cluster
    ]
    project_id        = mongodbatlas_cluster.source_cluster.project_id
    cluster_name      = mongodbatlas_cluster.source_cluster.name
    description       = var.snapshot.description
    retention_in_days = var.snapshot.retention_in_days
}

resource "time_static" "snapshot_time" {
  triggers = {
    # Save the time each switch of an AMI id
    timestamp = mongodbatlas_cloud_backup_snapshot.snapshot.created_at 
  }
}

# Example is set up to such that source_cluster and target_cluster are in the same Project
# Example sets PIT time to that of snapshot, but can be any time after snapshot time
resource "mongodbatlas_cloud_backup_snapshot_restore_job" "restore_job" {
    depends_on = [
      mongodbatlas_cloud_backup_snapshot.snapshot
    ]
    project_id      = mongodbatlas_cloud_backup_snapshot.snapshot.project_id
    cluster_name    = mongodbatlas_cloud_backup_snapshot.snapshot.cluster_name
    snapshot_id     = mongodbatlas_cloud_backup_snapshot.snapshot.snapshot_id
    delivery_type_config   {
      target_project_id   = mongodbatlas_cloud_backup_snapshot.snapshot.project_id
      target_cluster_name = mongodbatlas_cluster.target_cluster.name
      point_in_time = var.restore_job.delivery_type_config.point_in_time
      point_in_time_utc_seconds = time_static.snapshot_time.unix
    }
  }