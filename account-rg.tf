# RG (Resource Group) where to create resource
resource "ibm_resource_group" "rg" {
  name = "${local.basename}-group"
  tags = var.tags
}

# Use this data source if your RG already exists
# Make sure to passe your RG's name
# data "ibm_resource_group" "rg" {
#   name = "demo"
# }