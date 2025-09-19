# terraform_repo

### Data Engineering Pipleline Infrasctructure

This repository contains the Terraform code to provision the necessary infrastructure on Google Cloud Platform for a dbt-based data engineering pipeline. The pipeline's purpose is to ingest, transform, and analyze blockchain data. <br>
The infrastructure provision includes:

<ul>
    <li>A dedicated Google Cloud Project.
    <li>A service account with the necessary permission to run dbt jobs.
    <li>Two BigQuery datasets:
        <ul>
            <li> staging: for raw and intermediate data.
            <li> data_mart: fro the final aggregated data.
        </ul>
    <li>Enabeled APIs required for the pipeline function.
</ul>

### Prerequisites

To use this terraform configuration, you need the following:

<ul>
    <li> <b>Google Cloud Account</b>: with an active billing account.
    <li> <b>Terraform CLI</b>: installed on your local machine.
    <li> <b>A Google Cloud Service Account Key</b>: in a JSON file.
    <li> <b>A GitHub repository</b>: for your dbt project.
</ul>

### Usage

Follow these steps to deploy the infrastructure to your Google Cloud account.

<ol>
    <li> <b>Clone the repositoriy:</b><br></li>
    <code>git clone https://github.com/NoobToDaMaximum/terraform_repo.git<br>
    cd terraform-github</code>
    <li> <b>Initialize Terraform:</b><br></li>
    <code>terraform init</code>
    <li> <b>Create a `terraform.tfvars` file:</b><br></li>
    Create a file named `terraform.tfvars` and add the following variables, replacing the values with your specific details:<br>
    <code>project_id = "your-gcp-project-id"<br>
    project_name = "your-gcp-project-name"<br>
    billing_account = "your-billing-account-id"</code>
    <li> <b>Validate and Plan:</b><br></li>
    Run `terraform plan` to see the resources that will be created without making any changes.<br>
    <code>terraform plan</code>
    <li> <b>Apply the changes:</b><br></li>
    Run `terraform apply` to provision the infrastructure in your Google Cloud project. Confirm with `yes` when prompted.<br>
    <code>terraform apply</code>
</ol>

### Outputs

After a successful `terraform apply`, the following key values will be displayed. These are important for configuring your dbt project and GitHub Actions workflow.

<ul>
    <li> <b>service_account_email</b>: The email of the service account created for dbt.
    <li> <b>project_id</b>: The ID of the newly created Google Cloud project.
</ul>

### Code Explanation

The core of the infrastructure is defined in `main.tf`, which uses the variables defined in `variables.tf`.

<ul>
<li><b>main.tf</b>: This file contains the primary resource definitions. It creates a Google Cloud project, enables necessary APIs, provisions a service account, and sets up two BigQuery datasets for a two-tier data architecture.</li>
<li><b>variables.tf</b>: This file defines the input parameters for the configuration, making it reusable. These variables are used to specify the project ID, project name, and billing account.</li>
</ul>
