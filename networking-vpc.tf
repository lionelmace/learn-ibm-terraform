# Use this VPC Data Source if your VPC already exists
# Comment everything as of Line 7
# Make sure to passe your VPC's name
# data "ibm_is_vpc" "vpc" {
#   name = "vpc-eu-de-iks"
# }

# a vpc
resource "ibm_is_vpc" "vpc" {
  name                      = "${local.basename}-vpc"
  resource_group            = local.resource_group_id
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
  resource_group  = local.resource_group_id
  ipv4_cidr_block = ibm_is_vpc_address_prefix.subnet_prefix.cidr
  tags            = var.tags
}

resource "ibm_is_public_gateway" "pgw" {
  name           = "${local.basename}-pgw"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-1"
  resource_group = local.resource_group_id
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
