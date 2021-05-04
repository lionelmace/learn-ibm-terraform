
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