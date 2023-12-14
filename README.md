# Learn terraform on IBM Cloud

> Estimated duration: 15 mins

This lab will provision a VPC, a Subnet, a SSH Key and a VSI (Virtual Server Instance) with a Floating IP in a new Resource Group within IBM Cloud.

You can then ssh into the newly created VSI.

## Before you begin

This lab requires the following command lines:

* [IBM Cloud CLI](https://github.com/IBM-Cloud/ibm-cloud-cli-release/releases)
* [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

> Unless you are Administrator of the Cloud Account, you need permissions to be able to provision VPC Resources. Ask the Administrator run the Terraform in `iam` folder.

## Lab

1. Clone this repository

    ```sh
    git clone https://github.com/lionelmace/learn-ibm-terraform
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

    > Required only if terraform is launched outside of Schematics.

1. Terraform must initialize the provider before it can be used.

    ```sh
    terraform init
    ```

1. Review the plan

    ```sh
    terraform plan
    ```

1. Start provisioning.

   > Estimated duration: 2 mins

    ```sh
    terraform apply
    ```

    Outputs look like this:

    ```sh
    ssh_connection_string = "ssh -i ./rsakey.pem root@VSI-FLOATING-IP"
    vsi_private_ip = "10.10.10.4"
    vsi_public_ip = "158.177.3.170"
    ```

2. Connect to the VSI

    ```sh
    ssh -i ./rsakey.pem root@PUBLIC_IP
    ```

3. Clean up the resources to avoid cost

    ```sh
    terraform destroy
    ```

## Additional commnands

1. Once provisioned, reads and outputs a Terraform state or plan file in a human-readable form.

    ```sh
    terraform show
    ```
