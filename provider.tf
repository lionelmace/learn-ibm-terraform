terraform {
  required_version = ">=1.9"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.77.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}

provider "ibm" {
  # Required if terraform is launched outside of Schematics
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}
