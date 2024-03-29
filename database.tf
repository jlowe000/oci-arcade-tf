## This configuration was generated by terraform-provider-oci

resource oci_database_autonomous_database export_arcade {
  admin_password = var.custom_adb_admin_password
  #autonomous_container_database_id = <<Optional value not found in discovery>>
  #autonomous_database_backup_id = <<Optional value not found in discovery>>
  #autonomous_database_id = <<Optional value not found in discovery>>
  #clone_type = <<Optional value not found in discovery>>
  compartment_id           = var.compartment_ocid
  cpu_core_count           = "1"
  data_safe_status         = "NOT_REGISTERED"
  data_storage_size_in_tbs = "1"
  db_name                  = "arcade"
  db_version               = "19c"
  db_workload              = "DW"
  display_name = "arcade"
  freeform_tags = {
  }
  is_auto_scaling_enabled = "false"
  is_data_guard_enabled   = "false"
  is_dedicated            = "false"
  is_free_tier            = var.is_free_tier
  #is_preview_version_with_service_terms_accepted = <<Optional value not found in discovery>>
  #is_refreshable_clone = <<Optional value not found in discovery>>
  license_model = "LICENSE_INCLUDED"
  nsg_ids = [
  ]
  open_mode        = "READ_WRITE"
  operations_insights_status = "NOT_ENABLED"
  permission_level = "UNRESTRICTED"
  #private_endpoint_label = <<Optional value not found in discovery>>
  #refreshable_mode = <<Optional value not found in discovery>>
  #source = <<Optional value not found in discovery>>
  #source_id = <<Optional value not found in discovery>>
  standby_whitelisted_ips = [
  ]
  state = "AVAILABLE"
  #subnet_id = <<Optional value not found in discovery>>
  #switchover_to = <<Optional value not found in discovery>>
  #timestamp = <<Optional value not found in discovery>>
  whitelisted_ips = [
  ]
}

resource oci_database_autonomous_database_wallet export_arcade_wallet {
    #Required
    autonomous_database_id = oci_database_autonomous_database.export_arcade.id
    password = var.custom_adb_admin_password
    base64_encode_content  = "true"
    generate_type = "SINGLE"
}

resource local_file export_arcade_wallet_file {
    content_base64 = oci_database_autonomous_database_wallet.export_arcade_wallet.content
    filename = "${path.module}/arcade-wallet.zip"
}