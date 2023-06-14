variable "ibmcloud_api_key" {
  type = string
}

variable "region" {
  type        = string
  default     = "eu-de"
  description = "Region where to deploy the resources"
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "training"]
}

variable "prefix" {
  type        = string
  default     = ""
  description = "A prefix for all resources to be created. If none provided a random prefix will be created"
}

resource "random_string" "random" {
  count = var.prefix == "" ? 1 : 0

  length  = 6
  special = false
}

locals {
  basename = lower(var.prefix == "" ? "tf-${random_string.random.0.result}" : var.prefix)
}

# variable "ssh_key_name" {
#   type        = string
#   default     = "my-rsa-key"
#   description = "Name of an existing VPC SSH key to inject into the bastion and instance to allow remote connection"
# }

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

# variable "resource_group" {
#   type        = string
#   default     = "terraform"
#   description = "Resource group where to create resources"
# }

variable "image_name" {
  type        = string
  default     = "ibm-ubuntu-18-04-1-minimal-amd64-2"
  description = "Name of the image to use for the private instance"
}

variable "profile_name" {
  type        = string
  description = "Instance profile to use for the private instance"
  default     = "cx2-2x4"
}