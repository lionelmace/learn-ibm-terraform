# where to create resource
resource "ibm_resource_group" "rg" {
  name = "${local.basename}-group"
  tags = var.tags
}
