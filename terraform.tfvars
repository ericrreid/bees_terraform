atlas_access = {
  public_key  = ""
  private_key = ""
}

project = {
  name   = ""
  org_id = ""
}

cluster = {
  project_id = ""
  provider_name = "AZURE"
  name = ""
  provider_instance_size_name = ""
  cluster_type = "REPLICASET"
  mongodb_major_version = "4.4"
  cloud_backup = true
  replication_specs = {
    num_shards = 1
    regions_config = {
      region_name     = "US_EAST_2"
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
}
