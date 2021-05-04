# Learn terraform on IBM Cloud

1. Export API credential tokens as environment variables

    ```sh
    export TF_VAR_ibmcloud_api_key="Your IBM Cloud API Key"
    ```

1. Terraform must initialize the provider before it can be used.

    ```sh
    terraform init
    ```

1. Start provisioning

    ```sh
    terraform apply
    ```

1. Once provisioned, reads and outputs a Terraform state or plan file in a human-readable form.

    ```sh
    terraform show
    ```

1. Clean up

    ```sh
    terraform destroy
    ```
