data "ibm_resource_group" "resource_group" {
  name = "Default"
}

resource "ibm_is_vpc" "vpc" {
  name = var.vpc_name
  default_network_acl_name    = "${var.vpc_name}-edge-acl"
  default_security_group_name = "${var.vpc_name}-default-sg"
  default_routing_table_name  = "${var.vpc_name}-default-table"
  no_sg_acl_rules             = false
}

resource "ibm_is_subnet" "subnet" {
  name            = "${var.vpc_name}-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = var.zone
  total_ipv4_address_count = 256
}

# Resource to create COS instance if create_cos_instance is true
resource "ibm_resource_instance" "cos_instance" {
  name              = var.cos_name
  # resource_group_id = data.ibm_resource_group.resource_group.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  parameters = {
    service-endpoints: "private"
  }
}

resource "ibm_container_vpc_cluster" "cluster" {
  name              = var.cluster_name
  vpc_id            = ibm_is_vpc.vpc.id
  # kube_version      = "4.17.28_openshift"
  # kube_version      = "1.32.5"
  worker_count      = 2
  resource_group_id = data.ibm_resource_group.resource_group.id
  flavor            = "bx3d.4x20"
  disable_public_service_endpoint = true
  cos_instance_crn  = ibm_resource_instance.cos_instance.id
  zones {
    subnet_id = ibm_is_subnet.subnet.id
    name      = var.zone
  }
  entitlement = var.ocp_entitlement

}

data "ibm_container_vpc_cluster" "cluster_data" {
  name              = var.cluster_name
  depends_on = [ ibm_container_vpc_cluster.cluster ]
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = data.ibm_container_vpc_cluster.cluster_data.id
  # endpoint_type = "vpe"
}

provider "kubernetes" {
  host  = data.ibm_container_cluster_config.cluster_config.host
  token = data.ibm_container_cluster_config.cluster_config.token
}


resource "kubernetes_namespace" "example" {
depends_on = [ ibm_is_security_group_rule.kube_ingress_tcp_443, ibm_is_security_group_rule.kube_ingress_tcp_80 ]
  metadata {
    name = "jej-eg-namespace"
  }
}

data "ibm_is_lbs" "lbs" {
}

locals {
  lbs        = [for lb in data.ibm_is_lbs.lbs.load_balancers : lb if length(lb.public_ips) > 0 && lb.profile.family == "application"]
  public_lbs = [for lb in local.lbs : lb.id]
}

resource "ibm_is_security_group" "kube_security_group" {
  name           = "${var.prefix}-kube-security-group"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = data.ibm_resource_group.resource_group.id
}

resource "ibm_is_security_group_target" "kube_security_group_target" {
  security_group = ibm_is_security_group.kube_security_group.id
  target         = "r018-4479ffc4-35ee-4549-b551-4bf077cdf203"

locals {
  inbound_cidrs = concat(var.inbound_cidrs, var.iks_control_plane_cidrs)
}

resource "ibm_is_security_group_rule" "kube_ingress_tcp_80" {
  for_each = tomap({
    for rule in local.inbound_cidrs : rule => {}
  })
  group     = ibm_is_security_group.kube_security_group.id
  direction = "inbound"
  remote    = each.key
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "kube_ingress_tcp_443" {
  for_each = tomap({
    for rule in local.inbound_cidrs : rule => {}
  })
  group     = ibm_is_security_group.kube_security_group.id
  direction = "inbound"
  remote    = each.key
  tcp {
    port_min = 443
    port_max = 443
  }
}

resource "ibm_is_security_group_rule" "kube_egress_tcp" {
  group     = ibm_is_security_group.kube_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 30000
    port_max = 32767
  }
}

resource "ibm_is_security_group_rule" "kube_egress_udp" {
  group     = ibm_is_security_group.kube_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  udp {
    port_min = 30000
    port_max = 32767
  }
}

