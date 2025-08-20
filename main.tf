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
  # resource_group_id = var.resource_group_id
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
}

provider "kubernetes" {
  host  = data.ibm_container_cluster_config.cluster_config.host
  token = data.ibm_container_cluster_config.cluster_config.token
}


resource "kubernetes_namespace" "example" {
  metadata {
    name = "jej-eg-namespace"
  }
}
