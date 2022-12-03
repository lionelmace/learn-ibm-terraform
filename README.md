# Learn terraform on IBM Cloud

This lab will provision a VPC, a subnet, and a VSI in a Resource Group within IBM Cloud.

## Before you begin

This lab requires:

    * [IBM Cloud CLI](https://github.com/IBM-Cloud/ibm-cloud-cli-release/releases)
    * [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) to run the Terraform commands.
    * [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) to clone source code repository.

Unless you are Administrator of the Account, you need permissions to be able to provision VPC Resources. Ask the Administrator run the Terraform in `iam` folder.

## Lab

1. Clone this repository

    ```sh
    git clone https://github.com/lionelmace/learn-ibm-terraform
    ```

1. Create a SSH key

    ```sh
    ssh-keygen -t rsa -b 4096
    ```

1. Copy the public key

    ```sh
    cat mysshkey.pub
    ```

1. Create an IBM Cloud API either in the [console](https://cloud.ibm.com/iam/apikeys) or using the CLI

    ```sh
    ibmcloud iam api-key-create my-api-key
    ```

    > Make sure to preserve the API Key.

1. Export API credential tokens as environment variables

    ```sh
    export TF_VAR_ibmcloud_api_key="Your IBM Cloud API Key"
    ```

1. Edit the file `testing.auto.tfvars` to the Resource Group and the SSH Key.

1. Terraform must initialize the provider before it can be used.

    ```sh
    terraform init
    ```

1. Review the plan

    ```sh
    terraform plan -var-file="testing.auto.tfvars"
    ```

1. Start provisioning

    ```sh
    terraform apply -var-file="testing.auto.tfvars"
    ```

1. Once provisioned, reads and outputs a Terraform state or plan file in a human-readable form.

    ```sh
    terraform show
    ```

1. Clean up

    ```sh
    terraform destroy
    ```
