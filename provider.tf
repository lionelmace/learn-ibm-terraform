terraform {
  required_version = ">=1.3"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.50.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}
