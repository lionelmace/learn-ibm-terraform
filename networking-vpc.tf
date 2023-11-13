
# where to create resource
resource "ibm_resource_group" "rg" {
  name = "${local.basename}-group"
  tags = var.tags
}

# a vpc
resource "ibm_is_vpc" "vpc" {
  name                      = "${local.basename}-vpc"
  resource_group            = ibm_resource_group.rg.id
  address_prefix_management = "manual"
  tags                      = var.tags
}

# its address prefix
resource "ibm_is_vpc_address_prefix" "subnet_prefix" {
  name = "${local.basename}-zone-1"
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc.id
  cidr = "10.10.10.0/24"
}

# a subnet
resource "ibm_is_subnet" "subnet" {
  name            = "${local.basename}-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  resource_group  = ibm_resource_group.rg.id
  ipv4_cidr_block = ibm_is_vpc_address_prefix.subnet_prefix.cidr
  tags            = var.tags
}

resource "ibm_is_public_gateway" "pgw" {
  name           = "${local.basename}-pgw"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-1"
  resource_group = ibm_resource_group.rg.id
  tags           = var.tags
}

# Enable SSH Inbound Rule
resource "ibm_is_security_group_rule" "sg-rule-inbound-ssh" {
  group     = ibm_is_vpc.vpc.default_security_group
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 22
    port_max = 22
  }
}
