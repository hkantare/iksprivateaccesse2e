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
  default     = "jej-cluster-vpc-iks-e2e"
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
  default     = "jej-cos-mon-iks-e2e"
}

variable "resource_group_id" {
  type        = string
  default     = "default"
}

variable "cluster_name" {
  type        = string
  default     = "jej-cluster-vpc-iks-e2e"
}

variable "inbound_cidrs" {
  description = "List of inbound CIDR"
  type        = list(string)
  default = [
    // Akamai GTM https://control.akamai.com/apps/firewall-rules/#/cidr-blocks
    "193.108.155.118",
    "8.18.43.199",
    "8.18.43.240",
    "66.198.8.167",
    "66.198.8.168",
    "67.220.143.216/31",
    "173.205.7.116/31",
    "209.249.98.36/31",
    "207.126.104.118/31",
    "63.217.211.110/31",
    "63.217.211.116/31",
    "204.2.159.68/31",
    "209.107.208.188/31",
    "124.40.41.200/29",
    "125.252.224.36/31",
    "125.56.219.52/31",
    "192.204.11.4/31",
    "204.1.136.238/31",
    "204.2.160.182/31",
    "204.201.160.246/31",
    "205.185.205.132/31",
    "220.90.198.178/31",
    "60.254.173.30/31",
    "61.111.58.82/31",
    "63.235.21.192/31",
    "64.145.89.236/31",
    "65.124.174.194/31",
    "69.31.121.20/31",
    "69.31.138.100/31",
    "77.67.85.52/31",
    "203.69.138.120/30",
    "66.198.26.68/30",
    "201.33.187.68/30",
    "2.16.0.0/13",
    "23.0.0.0/12",
    "23.192.0.0/11",
    "23.32.0.0/11",
    "23.64.0.0/14",
    "23.72.0.0/13",
    "69.192.0.0/16",
    "72.246.0.0/15",
    "88.221.0.0/16",
    "92.122.0.0/15",
    "95.100.0.0/15",
    "96.16.0.0/15",
    "96.6.0.0/15",
    "104.64.0.0/10",
    "118.214.0.0/16",
    "172.232.0.0/13",
    "173.222.0.0/15",
    "184.24.0.0/13",
    "184.50.0.0/15",
    "184.84.0.0/14",
    // Akamai Control Center SiteShield Map (contact Rahul.Kadgekar@ibm.com)
    "104.117.66.0/24",
    "104.71.216.0/24",
    "104.71.217.0/24",
    "104.93.21.0/24",
    "168.143.242.0/24",
    "168.143.243.0/24",
    "172.232.0.0/24",
    "172.232.1.0/24",
    "172.232.11.0/24",
    "173.223.20.0/24",
    "184.26.95.0/24",
    "184.28.156.0/24",
    "184.28.194.0/24",
    "184.30.41.0/24",
    "184.31.1.0/24",
    "184.51.3.0/24",
    "2.23.5.0/24",
    "23.192.164.0/24",
    "23.198.14.0/24",
    "23.213.52.0/24",
    "23.214.88.0/24",
    "23.218.93.0/24",
    "23.220.96.0/24",
    "23.34.240.0/24",
    "23.35.71.0/24",
    "23.38.109.0/24",
    "23.43.48.0/24",
    "23.43.49.0/24",
    "23.44.170.0/24",
    "23.47.58.0/24",
    "23.48.209.0/24",
    "23.48.94.0/24",
    "23.56.168.0/24",
    "23.62.35.0/24",
    "66.198.8.0/24",
    "67.220.142.0/24",
    "69.174.30.128/25",
    "92.123.122.0/24",
    "96.7.74.0/24",
    // TaaS Private Worker Outbound IP List (https://github.ibm.com/TAAS/network-reports/blob/master/outbound_ip.md)
    "10.74.194.135",
    "10.186.167.215",
    "10.187.225.32/28",
    // GPVPN Gateways Outbound IP List (https://confluence.softlayer.local/display/NETGOVPUB/IBM+Cloud+Operator+Remote+Access+VPN)
    "169.47.119.36",
    "169.60.119.4",
    "169.62.119.4",
    "158.175.119.4",
    "149.81.119.4",
    "169.38.119.4",
    "165.192.119.4",
    "135.90.119.4",
    "169.57.139.4",
    // Schematics https://cloud.ibm.com/docs/schematics?topic=schematics-allowed-ipaddresses
    "10.123.76.192/26",
    "10.194.127.64/26",
    "10.75.204.128/26",
    "149.81.123.64/27",
    "149.81.135.64/28",
    "158.177.210.176/28",
    "158.177.216.144/28",
    "161.156.138.80/28",
    "159.122.111.224/27",
    "161.156.37.160/27"
  ]
}

variable "prefix" {
  description = "The prefix added to each resource name"
  type        = string
  default     = "ikssch"
}
