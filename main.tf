
# where to create resource
data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

# a vpc
resource "ibm_is_vpc" "vpc" {
  name                      = format("%s-%s", var.prefix, "vpc")
  resource_group            = data.ibm_resource_group.resource_group.id
  address_prefix_management = "manual"
  tags                      = var.tags
}

# its address prefix
resource "ibm_is_vpc_address_prefix" "subnet_prefix" {
  name = format("%s-%s", var.prefix, "zone-1")
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc.id
  cidr = "10.10.10.0/24"
}

# a subnet
resource "ibm_is_subnet" "subnet" {
  name            = format("%s-%s", var.prefix, "subnet")
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  resource_group  = data.ibm_resource_group.resource_group.id
  ipv4_cidr_block = ibm_is_vpc_address_prefix.subnet_prefix.cidr
  tags            = var.tags
}

# Create a VSI
data "ibm_is_image" "image" {
  name = var.image_name
}

# ssh key to inject into the vsi and the instance
# data "ibm_is_ssh_key" "sshkey" {
#   name = var.ssh_key_name
# }
resource "ibm_is_ssh_key" "sshkey" {
  name           = format("%s-%s", var.prefix, "ssh-key")
  resource_group = data.ibm_resource_group.resource_group.id
  public_key     = var.ssh_public_key
}

# Trying to use code below to avoid passing the key as argument
# Error: [DEBUG] Create SSH Key ssh: short read
# BEGIN
# resource "tls_private_key" "example" {
#   count     = var.ssh_key_id == null ? 1 : 0
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
#
# resource "ibm_is_ssh_key" "sshkey" {
#   count          = var.ssh_key_id == null ? 1 : 0
#   name           = format("%s-%s", var.prefix, "ssh-key")
#   resource_group = data.ibm_resource_group.resource_group.id
#   public_key     = var.ssh_public_key != null ? var.ssh_public_key : tls_private_key.example[0].public_key_openssh
# }
# END

resource "ibm_is_instance" "instance" {
  name           = format("%s-%s", var.prefix, "vsi")
  vpc            = ibm_is_vpc.vpc.id
  zone           = ibm_is_subnet.subnet.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  # keys           = [data.ibm_is_ssh_key.sshkey.id]
  keys           = [ibm_is_ssh_key.sshkey[0].id]
  resource_group = data.ibm_resource_group.resource_group.id
  tags           = var.tags

  primary_network_interface {
    subnet = ibm_is_subnet.subnet.id
  }

  boot_volume {
    name = format("%s-%s", var.prefix, "boot")
  }
}
