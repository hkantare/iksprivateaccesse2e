variable "region" {
  type        = string
  default     = "ca-mon"
  description = "IBM Cloud region"
}

variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud api key"
  sensitive = true
}

variable "zone" {
  type        = string
  default     = "ca-mon-1"
}

variable "vpc_name" {
  type        = string
  default     = "jej-cluster-vpc-e2e"
}

variable "ocp_entitlement" {
  type        = string
  description = "Value that is applied to the entitlements for OCP cluster provisioning"
  default     = "cloud_pak"
}


# variable "ssh_public_key" {
#   description = "SSH public key for VSI access"
#   type        = string
# }

# variable "image_id" {
#   type        = string
#   description = "Image ID (e.g., Ubuntu)"
#   # default = "r058-59771163-388d-4aae-b513-870dce83f1ec" #value for mon
#   default = "r038-21e26a8e-ded5-4934-908b-a6524300cb2b" #value for tor
  
# }

# variable "profile" {
#   type        = string
#   default     = "bx3d-2x10"
# }

# variable "app_port" {
#   type        = number
#   default     = 3000
# }

# variable "debug_level" {
#   type        = string
#   default     = "TRACE"
#   description = "The log level for debugging. Valid values: TRACE, DEBUG, INFO, WARN, ERROR"
# }

variable "cos_name" {
  type        = string
  default     = "jej-cos-mon-e2e"
}

variable "resource_group_id" {
  type        = string
  default     = "default"
}