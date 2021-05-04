terraform {
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.23.2"
    }
  }
  required_version = ">= 0.14"
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

# where to create resource, defaults to the default resource group
data "ibm_resource_group" "resource_group" {
  name       = var.resource_group
  is_default = var.resource_group == null ? true : null
}

# a vpc
resource "ibm_is_vpc" "tf-vpc" {
  name                      = var.vpc_name
  resource_group            = data.ibm_resource_group.resource_group.id
#   address_prefix_management = "manual"
}