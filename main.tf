/*
 * This file contains the main Terraform configuration for the Google Cloud project.
 * It provisions the necessary infrastructure for the data engineering pipeline.
 */

# Configure the Google Cloud provider.
# The provider is responsible for creating and managing resources in your GCP account.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

# Create a new Google Cloud Project.
# This project will serve as the container for all other resources.
resource "google_project" "new_project" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account
}

# Enable necessary Google Cloud APIs.
# These APIs are required for the dbt pipeline to function and for Terraform to manage resources.
resource "google_project_service" "compute_api" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "bigquery.googleapis.com",
  ])
  project            = google_project.new_project.project_id
  service            = each.key
  disable_on_destroy = false
}

# Create a service account for dbt.
# This service account will be used by the GitHub Actions workflow to run dbt commands.
resource "google_service_account" "dbt_service_account" {
  account_id   = "dbt-executor"
  display_name = "dbt Executor Service Account"
  project      = google_project.new_project.project_id
}

# Assign the 'BigQuery Job User' role to the service account.
# This role allows the service account to run BigQuery jobs and queries.
resource "google_project_iam_member" "bigquery_job_user" {
  project = google_project.new_project.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt_service_account.email}"
}

# Create the staging dataset in BigQuery.
# This dataset is where the raw data will be staged and transformed.
resource "google_bigquery_dataset" "staging_dataset" {
  dataset_id = "staging"
  project    = google_project.new_project.project_id
  location   = "US"
  depends_on = [google_project_service.compute_api]
}

# Grant the dbt service account editor access to the staging dataset.
# This allows the account to create, update, and delete tables in the staging dataset.
resource "google_bigquery_dataset_iam_member" "staging_editor" {
  dataset_id = google_bigquery_dataset.staging_dataset.dataset_id
  project    = google_project.new_project.project_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt_service_account.email}"
}

# Create the data mart dataset in BigQuery.
# This dataset will hold the final, aggregated data from the pipeline.
resource "google_bigquery_dataset" "data_mart_dataset" {
  dataset_id = "data_mart"
  project    = google_project.new_project.project_id
  location   = "US"
  depends_on = [google_project_service.compute_api]
}

# Grant the dbt service account editor access to the data mart dataset.
# This allows the account to create and manage the final data mart tables.
resource "google_bigquery_dataset_iam_member" "data_mart_editor" {
  dataset_id = google_bigquery_dataset.data_mart_dataset.dataset_id
  project    = google_project.new_project.project_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt_service_account.email}"
}

# Define outputs for the Terraform module.
# Outputs are values that will be displayed to the user after the infrastructure is created.
output "service_account_email" {
  description = "The email of the dbt service account"
  value       = google_service_account.dbt_service_account.email
}

output "project_id" {
  description = "The ID of the created Google Cloud project"
  value       = google_project.new_project.project_id
}
