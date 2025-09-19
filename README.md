# terraform_repo

### Data Engineering Pipleline Infrasctructure

This repository contains the Terraform code to provision the necessary infrastructure on Google Cloud Platform for a dbt-based data engineering pipeline. The pipeline's purpose is to ingest, transform, and analyze blockchain data. <br>
The infrastructure provision includes:

- A dedicated Google Cloud Project.
- A service account with the necessary permission to run dbt jobs.
- Two BigQuery datasets:
  - staging: for raw and intermediate data.
  - data_mart: fro the final aggregated data.
- Enabeled APIs required for the pipeline function.

### Prerequisites

To use this terraform configuration, you need the following:

- <b>Google Cloud Account</b>: with an active billing account.
- <b>Terraform CLI</b>: installed on your local machine.
- <b>A Google Cloud Service Account Key</b>: in a JSON file.
- <b>A GitHub repository</b>: for your dbt project.

### Usage

Follow these steps to deploy the infrastructure to your Google Cloud account.

### 1. Clone the repository:

```
    git clone https://github.com/NoobToDaMaximum/terraform_repo.git <br>
    cd terraform-github
```

### 2. Initialize Terraform:

```
    terraform init
```

### 3. Create a `terraform.tfvars` file:

Create a file named `terraform.tfvars` and add the following variables, replacing the values with your specific details:<br>

```
    project_id = "your-gcp-project-id"<br>
    project_name = "your-gcp-project-name"<br>
    billing_account = "your-billing-account-id"
```

### 4. Validate and Plan:

Run `terraform plan` to see the resources that will be created without making any changes.<br>

```
    terraform plan
```

### 5. Apply the changes:

Run `terraform apply` to provision the infrastructure in your Google Cloud project. Confirm with `yes` when prompted.<br>

```
terraform apply
```

### Outputs

After a successful `terraform apply`, the following key values will be displayed. These are important for configuring your dbt project and GitHub Actions workflow.

- <b>service_account_email</b>: The email of the service account created for dbt.
- <b>project_id</b>: The ID of the newly created Google Cloud project.

### Code Explanation

The core of the infrastructure is defined in `main.tf`, which uses the variables defined in `variables.tf`.

- <b>main.tf</b>: This file contains the primary resource definitions. It creates a Google Cloud project, enables necessary APIs, provisions a service account, and sets up two BigQuery datasets for a two-tier data architecture.
- <b>variables.tf</b>: This file defines the input parameters for the configuration, making it reusable. These variables are used to specify the project ID, project name, and billing account.
