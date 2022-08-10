provider "mongodbatlas" {
  public_key  = var.atlas_access.public_key
  private_key = var.atlas_access.private_key
}

resource "mongodbatlas_cluster" "source_cluster" {
  # These uniquely identify the existing cluster (it gets created otherwise)
  project_id = var.source_cluster.project_id
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
  project_id = var.target_cluster.project_id
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
  project_id   = var.backup_schedule.project_id
  cluster_name = var.backup_schedule.cluster_name

  # Example using current schedule of the BEES-PROD-US/BERLINER-PROD/berliner Cluster
  reference_hour_of_day    = var.backup_schedule.reference_hour_of_day
  reference_minute_of_hour = var.backup_schedule.reference_minute_of_hour
  restore_window_days      = var.backup_schedule.restore_window_days

  # This will now add the desired policy items to the existing mongodbatlas_cloud_backup_schedule resource
  policy_item_hourly {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = 2
  }
#  policy_item_daily {
#    frequency_interval = 
#    retention_unit     = ""
#    retention_value    = 
#  }
  policy_item_weekly {
    frequency_interval = 6    # Denotes Saturday
    retention_unit     = "months"
    retention_value    = 1
  }
  policy_item_monthly {
    frequency_interval = 40   # Denotes last day of month
    retention_unit     = "months"
    retention_value    = 12 
  }
}

resource "mongodbatlas_cloud_backup_snapshot" "snapshot" {
    project_id        = mongodbatlas_cluster.source_cluster.project_id
    cluster_name      = mongodbatlas_cluster.source_cluster.name
    description       = "Test Snapshot for Terraform Testing"
    retention_in_days = 1
}

resource "mongodbatlas_cloud_backup_snapshot_restore_job" "restore_job" {
    project_id      = mongodbatlas_cloud_backup_snapshot.snapshot.project_id
    cluster_name    = mongodbatlas_cloud_backup_snapshot.snapshot.cluster_name
    snapshot_id     = mongodbatlas_cloud_backup_snapshot.snapshot.snapshot_id
    delivery_type_config   {
      automated           = true
      target_cluster_name = "BackupTarget"
      target_project_id   = mongodbatlas_cloud_backup_snapshot.snapshot.project_id
    }
  }