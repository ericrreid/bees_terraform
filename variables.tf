variable "atlas_access" {
  type = object(
    {
      public_key  = string
      private_key = string
    }
  )
}

variable "our_project" {
  type = object(
    {
      name   = string
      org_id = string
    }
  )
}

variable "source_cluster" {
  type = object(
    {
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

variable "target_cluster" {
  type = object(
    {
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
      policy_item_hourly = object({
        frequency_interval = number
        retention_unit = string
        retention_value = number
      }) 
      policy_item_daily = object({
        frequency_interval = number
        retention_unit = string
        retention_value = number
      }) 
      policy_item_weekly = object({
        frequency_interval = number
        retention_unit = string
        retention_value = number
      }) 
      policy_item_monthly = object({
        frequency_interval = number
        retention_unit = string
        retention_value = number
      }) 
    }
  )
}

variable "snapshot" {
  type = object(
    {
      description       = string
      retention_in_days = number
      project_id        = string
      cluster_name      = string
    }
  )
}

variable "restore_job" {
  type = object(
    {
      project_id      = string
      cluster_name    = string
      snapshot_id     = string
      delivery_type_config = object (
        {
          point_in_time = bool
          point_in_time_utc_seconds = number  
          target_cluster_name =  string
          target_project_id   =  string
        }
      )
    }
  )
}