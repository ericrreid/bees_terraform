atlas_access = {
  public_key  = ""
  private_key = ""
}

our_project = {
  name   = "BEEStest"
  org_id = ""
}

source_cluster = {
  provider_name = "AZURE"
  name = "BackupSource"
  provider_instance_size_name = "M10"
  cluster_type = "REPLICASET"
  mongodb_major_version = "4.4"
  cloud_backup = true
  replication_specs = {
    num_shards = 1
    regions_config = {
      region_name     = "ASIA_SOUTH_EAST"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
}

target_cluster = {
  provider_name = "AZURE"
  name = "BackupTarget"
  provider_instance_size_name = "M10"
  cluster_type = "REPLICASET"
  mongodb_major_version = "4.4"
  cloud_backup = false
  replication_specs = {
    num_shards = 1
    regions_config = {
      region_name     = "ASIA_SOUTH_EAST"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
}

backup_schedule = {
  project_id = ""
  cluster_name = ""
  reference_hour_of_day = 22
  reference_minute_of_hour = 00
  restore_window_days = 2

# This will now add the desired policy items to the existing mongodbatlas_cloud_backup_schedule resource
  policy_item_hourly = {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = 2
  }
# Unused in this example
  policy_item_daily = {
    frequency_interval = 0
    retention_unit     = ""
    retention_value    = 0
  }
  policy_item_weekly = {
    frequency_interval = 6    # Denotes Saturday
    retention_unit     = "months"
    retention_value    = 1
  }
  policy_item_monthly = {
    frequency_interval = 40   # Denotes last day of month
    retention_unit     = "months"
    retention_value    = 12 
  }
}

snapshot = {
  project_id        = ""
  cluster_name      = ""
  description = "Test Snapshot for Terraform Testing"
  retention_in_days = 1
}

restore_job = {
  project_id      = ""
  cluster_name    = ""
  snapshot_id     = ""
  delivery_type_config = {
    point_in_time = true
    point_in_time_utc_seconds = 0
    target_project_id  = ""
    target_cluster_name = ""
  }
}
