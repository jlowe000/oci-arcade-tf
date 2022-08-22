variable tenancy_ocid {}
# syntax = "ocid1.compartment.oc1..XXXX"
variable region {}
variable compartment_ocid {}
# syntax = "ocid1.compartment.oc1..XXXX"
variable current_user_ocid {}
variable enable_api_key { default = "true" }
variable git_repo { default = "https://github.com/jlowe000/oci-arcade.git" }
variable compute_shape { default = "VM.Standard.A1.Flex" }
variable arcade-web_source_image_id { default = "ocid1.image.oc1.XXXX" }
variable custom_ssh_key { default = "ssh-rsa XXXX" }
variable is_free_tier { default = "true" }
variable custom_adb_admin_password { default = "WelcomeTiger123" }
variable apigw-dn { default = "" }
variable bootstrap_server { default = "kafka_kafka_1:9092" }
variable kafka_user { default = "" }
variable kafka_password { default = "" }
variable topic { default = "oci-arcade-events" }

locals {
  bucket_ns = data.oci_objectstorage_namespace.user_namespace.namespace
}
