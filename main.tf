# Configure Google Cloud Provider
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

# Create Google Cloud Project
resource "google_project" "new_project" {
    name       = var.project_name
    project_id = var.project_id
    billing_account = var.billing_account
}

# Enable necessary APIs
resource "google_project_service" "compute_api" {
    for_each = toset([
        "cloudresourcemanager.googleapis.com",
        "iam.googleapis.com",
        "bigquery.googleapis.com",
    ])
    project = google_project.new_project.project_id
    service = each.key
    disable_on_destroy = false
}

# Service Account for dbt
resource "google_service_account" "dbt_service_account" {
    account_id   = "dbt-executor"
    display_name = "dbt Executor Service Account"
    project      = google_project.new_project.project_id
}

# Big Query Permissions to service Account
resource "google_project_iam_member" "bigquery_job_user" {
    project = google_project.new_project.project_id
    role    = "roles/bigquery.jobUser"
    member  = "serviceAccount:${google_service_account.dbt_service_account.email}"
}

# Create BigQuery Dataset
resource "google_bigquery_dataset" "staging_dataset" {
    dataset_id = "staging"
    project    = google_project.new_project.project_id
    location   = "US"
    depends_on = [ google_project_service.compute_api ]
}

# Permissions for BigQuery Dataset
resource "google_bigquery_dataset_iam_member" "staging_editor" {
    dataset_id = google_bigquery_dataset.staging_dataset.dataset_id
    project    = google_project.new_project.project_id
    role       = "roles/bigquery.dataEditor"
    member     = "serviceAccount:${google_service_account.dbt_service_account.email}"
}

# Create Data mart Bigquery Dataset
resource "google_bigquery_dataset" "data_mart_dataset" {
    dataset_id = "data_mart"
    project    = google_project.new_project.project_id
    location   = "US"
    depends_on = [ google_project_service.compute_api ]
}

#Permissions to data mart dataset
resource "google_bigquery_dataset_iam_member" "data_mart_editor" {
    dataset_id = google_bigquery_dataset.data_mart_dataset.dataset_id
    project    = google_project.new_project.project_id
    role       = "roles/bigquery.dataEditor"
    member     = "serviceAccount:${google_service_account.dbt_service_account.email}"
}

# Outputs
output "service_account_email" {
    description = "The email of the dbt service account"
    value = google_service_account.dbt_service_account.email
}

output "project_id" {
    description = "The ID of the created Google Cloud project"
    value       = google_project.new_project.project_id
}