
# where to create resource
resource "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

# a vpc
resource "ibm_is_vpc" "vpc" {
  name                      = var.name
  resource_group            = ibm_resource_group.resource_group.id
  address_prefix_management = "manual"
}

# its address prefix
resource "ibm_is_vpc_address_prefix" "subnet_prefix" {
  name = "${var.name}-zone-1"
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc.id
  cidr = "10.10.10.0/24"
}

# a subnet
resource "ibm_is_subnet" "subnet" {
  name            = "${var.name}-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  resource_group  = ibm_resource_group.resource_group.id
  ipv4_cidr_block = ibm_is_vpc_address_prefix.subnet_prefix.cidr
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
  name       = "my-ssh-key"
  public_key = var.ssh_public_key
}

resource "ibm_is_instance" "instance" {
  name           = "${var.name}"
  vpc            = ibm_is_vpc.vpc.id
  zone           = ibm_is_subnet.subnet.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  # keys           = [data.ibm_is_ssh_key.sshkey.id]
  keys           = [ibm_is_ssh_key.sshkey.id]
  resource_group = ibm_resource_group.resource_group.id

  primary_network_interface {
    subnet = ibm_is_subnet.subnet.id
  }

  boot_volume {
    name = "${var.name}-instance-boot"
  }
}
