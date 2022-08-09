variable "atlas_access" {
  type = object(
    {
      public_key  = string
      private_key = string
    }
  )
}

variable "project" {
  type = object(
    {
      name   = string
      org_id = string
    }
  )
}

variable "cluster" {
  type = object(
    {
      project_id = string
      provider_name = string
      name = string
      provider_instance_size_name = string
      cluster_type = string
      mongodb_major_version = string
      cloud_backup = bool
      replication_specs = object({
        num_shards = number
        regions_config = object({
          region_name     = string
          electable_nodes = number
          priority        = number
          read_only_nodes = number
        })
      }) 
    }
  )
}

variable "backup_schedule" {
  type = object(
    {
      project_id = string
      cluster_name = string
      reference_hour_of_day = number
      reference_minute_of_hour = number
      restore_window_days = number
    }
  )
}
