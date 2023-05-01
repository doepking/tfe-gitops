# Managing secure infrastructure with Terraform on the Google Cloud using GitOps
## Introduction and Project Motivation
This project offers a comprehensive guide on creating and managing secure infrastructure as code (IaC) on the Google Cloud Platform (GCP) using Terraform and the GitOps methodology. The infrastructure setup includes a VPC network to facilitate secure internal communication between a Compute Engine instance and a CloudSQL database. The project also utilizes Cloud Build to implement a CI/CD pipeline for seamless and automated deployment of Terraform changes to both development and production environments.

The infrastructure is designed to prevent sensitive information from being exposed in the Terraform output plan or logs. The private key of the SSH key pair and the database user password are stored in the secret manager, and access is restricted to authorized users and services only. 

## Key Concepts
### Virtual Private Cloud (VPC)
A VPC is a virtual network that provides a secure, isolated environment within a cloud infrastructure. It enables the separation of resources and controls access to them, ensuring that only authorized services and users can interact with the protected resources. In this project, a VPC is used to connect the Compute Engine instance and the CloudSQL database, allowing for secure internal communication between them.

### CloudSQL Database
CloudSQL is a fully managed database service provided by Google Cloud. In this project, we set up a CloudSQL database with a private IP, ensuring that it can only be accessed from within the VPC network. This setup provides an additional layer of security, as the database cannot be directly accessed from the public internet.

### Compute Engine Instance
The Compute Engine instance serves as a secure gateway to access the CloudSQL database. By setting up an SSH tunnel to the instance, users can securely connect to the database without exposing it to the public internet. This approach further enhances the security and control over access to the database.

### CI/CD with Cloud Build
The project uses Cloud Build for continuous integration and deployment. This CI/CD pipeline ensures that Terraform changes are automatically applied to the development and production environments upon merging pull requests. The pipeline also provides visibility into the Terraform plan for feature branches, allowing for evaluation and review before applying changes to the target environment.

## Technical Instructions

### Service Environment Overview
The service environment is designed to configure the Google Cloud Storage (GCS) bucket that holds the Terraform state files for both the development and production environments. Additionally, this environment establishes the CI/CD pipeline using Google Cloud Build. The default Cloud Build account of the service project functions as the principal account for governing all infrastructure across projects with owner-level permissions.

It is important to note that the service environment does not possess a backend. As a result, service-environment related Terraform commands must be executed locally within the service directory or be done manually.

**Note:** Due to the current limitations of Terraform, the connection between the GitHub repository and the Cloud Build trigger must be established manually.

#### Configuring the Service Environment
Customize the terraform.tfvars file in the service environment with the appropriate values for the variables project, region, location, bucket_name, github_repo_name, and github_repo_owner:

```hcl
project           = "your-service-project-name"
region            = "europe-west1"
location          = "EU"
bucket_name       = "your-gcs-bucket-name"
github_repo_name  = "your-github-repo"
github_repo_owner = "your-github-user-name"
```

Run the following Terraform commands in the service environment:
```bash
cd ./environments/service
terraform init
terraform plan
terraform apply
```

Establish the connection between the GitHub repository and the Cloud Build trigger manually via the Google Cloud Console:

a. Navigate to the [Cloud Build Triggers](https://console.cloud.google.com/cloud-build/triggers) page.

b. Select "Connect Repository".

c. Follow the provided instructions to link your GitHub repository.

Upon completing these steps, the service environment will be appropriately set up with a GCS bucket for storing Terraform state files and a CI/CD pipeline utilizing Google Cloud Build.

### Configuring your **dev** environment

Before applying the Terraform configuration for the **dev** environment, you need to update the backend configuration in the `backend.tf` file to point to the correct GCS bucket and prefix. You should also update the `terraform.tfvars` file with the appropriate values for the `project` variable.

```hcl
terraform {
  backend "gcs" {
    bucket = "your-gcs-bucket-name"
    prefix = "env/dev"
  }
}
```

```hcl
project         = "your-dev-project-id"
region          = "europe-west1"
zone            = "europe-west1-b"
instance_name   = "my-dev-mysql-instance"
instance_tier   = "db-f1-micro"
database_name   = "mydb_dev"
db_user_name    = "db_user"
network_name    = "my-dev-vpc-network"
ssh_user        = "ssh_user"
```

After updating these files, you can apply the Terraform configuration by running the following commands in your local development environment with the Google Cloud SDK & Terraform installed:

```bash
cd ./environments/dev
terraform init
terraform plan
terraform apply
```

To destroy the infrastructure, run the following command:

```bash
terraform destroy
```

Alternatively, you can use the Cloud Build trigger for automatically applying the Terraform infrastructure when pushing to the **dev** branch.

### Promoting your environment to **production**

Before applying the Terraform configuration for the **prod** environment, you need to update the backend configuration in the `backend.tf` file to point to the correct GCS bucket and prefix. You should also update the `terraform.tfvars` file with the appropriate values for the `project` variable.

```hcl
terraform {
  backend "gcs" {
    bucket = "your-gcs-bucket-name"
    prefix = "env/prod"
  }
}
```

```hcl
project         = "your-prod-project-id"
region          = "europe-west1"
zone            = "europe-west1-b"
instance_name   = "my-prod-mysql-instance"
instance_tier   = "db-f1-micro"
database_name   = "mydb_prod"
db_user_name    = "db_user"
network_name    = "my-prod-vpc-network"
ssh_user        = "ssh_user"
```

After updating these files, you can apply the Terraform configuration by running the following commands in your local development environment with the Google Cloud SDK & Terraform installed:

```bash
cd ./environments/prod
terraform init
terraform plan
terraform apply
```

To destroy the infrastructure, run the following command:

```bash
terraform destroy
```

Alternatively, you can use the Cloud Build trigger for automatically applying the Terraform infrastructure when pushing to the **prod** branch.

### Accessing the SSH Private Key

To access the SSH private key for the Compute Engine instance, use the following commands:

```bash
gcloud secrets versions access latest --project <project_id> --secret="vm-ssh-private-key" > vm_ssh_private_key.pem
chmod 600 vm_ssh_private_key.pem
ssh -i vm_ssh_private_key.pem <ssh_user>@<instance_external_ip>
```

### Connecting to CloudSQL
To connect to the CloudSQL database in the respective environment, start the CloudSQL proxy with the following command:

```bash
sudo /usr/local/bin/cloud_sql_proxy --private-ip <project_id>:<region>:<instance_name>
```

Then, in another terminal tab, connect to the database and enter the password from the Secret manager:

```bash
mysql -u db_user -p --host 127.0.0.1 --port 3306
```

### CI/CD and Branching Strategy
The CI/CD pipeline is set up using Cloud Build. To deploy Terraform changes, create a pull request from a feature branch to either the dev or prod branch. The pipeline will display the Terraform plan for evaluation, but it will not apply the changes automatically. To apply the changes, merge the pull request into the target branch (dev or prod).

Feature branches will only show the Terraform plan for evaluation and will not apply any changes.