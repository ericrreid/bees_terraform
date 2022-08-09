atlas_access = {
  public_key  = "svpecjar"
  private_key = "5bddb7f6-39db-42af-8bab-e33769338aac"
}

project = {
  name   = "BEEStest"
  org_id = "5e2b5933014b76f526e82eba"
}

cluster = {
  project_id = "62f1657ba782ac103e00ccd2"
  provider_name = "AZURE"
  name = "BackupTest"
  provider_instance_size_name = "M10"
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
  project_id = "62f1657ba782ac103e00ccd2"
  cluster_name = "BackupTest"
  reference_hour_of_day = 22
  reference_minute_of_hour = 00
  restore_window_days = 2
}
