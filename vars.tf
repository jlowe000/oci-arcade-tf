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

# arcade-web compute module variables
# compute parameters
variable "instance_count" {
  description = "Number of identical instances to launch from a single module."
  type        = number
  default     = 1
}

variable "instance_display_name" {
  description = "(Updatable) A user-friendly name for the instance. Does not have to be unique, and it's changeable."
  type        = string
  default     = "arcade=web"
}

variable "instance_flex_memory_in_gbs" {
  type        = number
  description = "(Updatable) The total amount of memory available to the instance, in gigabytes."
  default     = null
}

variable "instance_flex_ocpus" {
  type        = number
  description = "(Updatable) The total number of OCPUs available to the instance."
  default     = null
}

variable "instance_state" {
  type        = string
  description = "(Updatable) The target state for the instance. Could be set to RUNNING or STOPPED."
  default     = "RUNNING"

  validation {
    condition     = contains(["RUNNING", "STOPPED"], var.instance_state)
    error_message = "Accepted values are RUNNING or STOPPED."
  }
}

variable "shape" {
  description = "The shape of an instance."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "cloud_agent_plugins" {
  description = "Whether each Oracle Cloud Agent plugins should be ENABLED or DISABLED."
  type        = map(string)
  default = {
    autonomous_linux        = "ENABLED"
    bastion                 = "ENABLED"
    block_volume_mgmt       = "DISABLED"
    custom_logs             = "ENABLED"
    management              = "DISABLED"
    monitoring              = "ENABLED"
    osms                    = "ENABLED"
    run_command             = "ENABLED"
    vulnerability_scanning  = "ENABLED"
    java_management_service = "DISABLED"
  }
}

variable "source_ocid" {
  description = "The OCID of an image or a boot volume to use, depending on the value of source_type."
  type        = string
}

variable "source_type" {
  description = "The source type for the instance."
  type        = string
  default     = "image"
}

# operating system parameters
variable "ssh_public_keys" {
  description = "Public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance. To provide multiple keys, see docs/instance_ssh_keys.adoc."
  type        = string
  default     = null
}

# networking parameters
variable "assign_public_ip" {
  description = "Whether the VNIC should be assigned a public IP address."
  type        = bool
  default     = false
}

variable "public_ip" {
  description = "Whether to create a Public IP to attach to primary vnic and which lifetime. Valid values are NONE, RESERVED or EPHEMERAL."
  type        = string
  default     = "NONE"
}

# storage parameters
variable "boot_volume_backup_policy" {
  description = "Choose between default backup policies : gold, silver, bronze. Use disabled to affect no backup policy on the Boot Volume."
  type        = string
  default     = "disabled"
}

variable "block_storage_sizes_in_gbs" {
  description = "Sizes of volumes to create and attach to each instance."
  type        = list(string)
  default     = [50]
}

variable "local_cidr_block" {
  description = "Local CIDR Block for Network Security Group"
  type        = string
  default     = "0.0.0.0/0"
}

locals {
  bucket_ns = data.oci_objectstorage_namespace.user_namespace.namespace
}
