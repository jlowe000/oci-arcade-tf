output "arcade-web_compute_ip_addr" {
  value = try(module.arcade-web.public_ip[0], "")
}

output "arcade_adw_apex_url" {
  value = lookup(oci_database_autonomous_database.export_arcade.connection_urls[0],"apex_url")
}

output "objectstorage_namespace" {
  value = local.bucket_ns
}

output "region" {
  value = var.region
}

output "game_url" {
  value = "https://objectstorage.${var.region}.oraclecloud.com/n/${local.bucket_ns}/b/oci-arcade/o/consume-cloud/index.htm"
}

output "sqldev_url" {
  value = replace(lookup(oci_database_autonomous_database.export_arcade.connection_urls[0],"sql_dev_web_url"),"admin","ociarcade")
}

output "ssh-web_template" {
  value = "ssh -i ~/.ssh/id_rsa opc@${module.arcade-web.public_ip[0]}"
}
