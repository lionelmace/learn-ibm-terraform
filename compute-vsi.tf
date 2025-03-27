
variable "ssh_public_key" {
  description = "SSH Public Key. Get your ssh key by running `ssh-key-gen` command"
  type        = string
  default     = null
}

variable "ssh_key_id" {
  description = "ID of SSH public key stored in IBM Cloud"
  type        = string
  default     = null
}

variable "create_public_ip" {
  type    = bool
  default = true
}

# ibmcloud is images | grep ibm-ubuntu | grep "available"
variable "image_name" {
  type        = string
  default     = "ibm-ubuntu-24-04-minimal-amd64-1"
  description = "Name of the image to use for the private instance"
}

variable "profile_name" {
  type        = string
  description = "Instance profile to use for the private instance"
  default     = "cx2-2x4"
  # default     = "bx2-2x8"
}

data "ibm_is_image" "image" {
  name = var.image_name
}

resource "tls_private_key" "rsa_4096_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.rsa_4096_key.private_key_pem
  filename        = "rsakey.pem"
  file_permission = "0600"
}

# Generate an SSH Key
resource "ibm_is_ssh_key" "generated_ssh_key" {
  name           = "${local.basename}-ssh-key"
  resource_group = ibm_resource_group.rg.id
  # Replace by the line below if the Resource Group already exists
  # resource_group = data.ibm_resource_group.rg.id
  public_key = tls_private_key.rsa_4096_key.public_key_openssh
}

# Create a VSI (Virtual Server Instance)
resource "ibm_is_instance" "vsi" {
  name = "${local.basename}-vsi"
  vpc  = ibm_is_vpc.vpc.id
  # Replace by the line below if the VPC already exists
  # vpc            = data.ibm_is_vpc.vpc.id
  zone = ibm_is_subnet.subnet.zone
  # Replace by the line below if the Subnet already exists
  # zone           = data.ibm_is_vpc.vpc.subnets.0.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = [ibm_is_ssh_key.generated_ssh_key.id]
  resource_group = ibm_resource_group.rg.id
  # Replace by the line below if the Resource Group already exists
  # resource_group = data.ibm_resource_group.rg.id
  tags = var.tags

  primary_network_attachment {
    name = "vni-primary-att"
    virtual_network_interface {
      id = ibm_is_virtual_network_interface.vni.id
    }
  }

  boot_volume {
    name = "${local.basename}-boot"
  }
}

resource "ibm_is_virtual_network_interface" "vni" {
  name                      = "example-vni"
  allow_ip_spoofing         = false
  auto_delete               = false
  # When VNI targeted for VSI, enable_infrastructure_nat cannot be set to false
  enable_infrastructure_nat = true
  primary_ip {
    auto_delete = false
    address     = "10.10.10.8"
  }
  resource_group = ibm_resource_group.rg.id
  subnet         = ibm_is_subnet.subnet.id
  # Replace by the line below if the Subnet already exists
  # subnet = data.ibm_is_vpc.vpc.subnets.0.id
}

# A Public Floating IP for the VSI
resource "ibm_is_floating_ip" "public_ip" {
  # count = tobool(var.create_public_ip) ? 1 : 0

  name           = "${local.basename}-floating-ip"
  target         = ibm_is_instance.vsi.primary_network_attachment[0].virtual_network_interface[0].id
  resource_group = ibm_resource_group.rg.id
  tags           = var.tags
}