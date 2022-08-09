provider "mongodbatlas" {
  public_key  = var.atlas_access.public_key
  private_key = var.atlas_access.private_key
}

resource "mongodbatlas_cluster" "cluster" {
  # These uniquely identify the existing cluster (it gets created otherwise)
  project_id = var.cluster.project_id
  name = var.cluster.name
  provider_name = var.cluster.provider_name
  provider_instance_size_name = var.cluster.provider_instance_size_name
  cluster_type = var.cluster.cluster_type
  mongo_db_major_version = var.cluster.mongodb_major_version
  replication_specs { 
    num_shards = var.cluster.replication_specs.num_shards
    regions_config {
      region_name=var.cluster.replication_specs.regions_config.region_name
      electable_nodes=var.cluster.replication_specs.regions_config.electable_nodes
      priority=var.cluster.replication_specs.regions_config.priority
      read_only_nodes=var.cluster.replication_specs.regions_config.read_only_nodes
    }
  } 
  cloud_backup = var.cluster.cloud_backup # Set if not yet set
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
