variable user_id {}
variable enable_api_key { default = "true" }
variable tenancy_ocid { default = "ocid1.compartment.oc1..XXXX" }
variable region { default = "ap-sydney-1" }
variable bucket_ns { default = "oci-bucket-ns" }
variable compartment_ocid { default = "ocid1.compartment.oc1..XXXX" }
variable compute_shape { default = "VM.Standard.E2.1.Micro" }
variable arcade-web_source_image_id { default = "ocid1.image.oc1.ap-sydney-1.aaaaaaaasbprumtin47wvqprgbzbn6wrzct7afonp72lwur6bisgjq6rqphq" }
variable custom_ssh_key { default = "ssh-rsa XXXX" }
variable is_free_tier { default = "true" }
variable custom_adb_admin_password { default = "WelcomeTiger123" }
variable git_repo { default = "https://github.com/jlowe000/oci-arcade.git --branch free-tier" }