/*
 * This file defines the input variables for the Terraform configuration.
 * These variables allow you to customize the deployment without changing the code.
 */

# The unique ID of the Google Cloud project. This will be used to create all resources.
# It is recommended to use a lowercase, globally unique ID.
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

# The display name of the Google Cloud project.
# This name is human-readable and appears in the Google Cloud Console.
variable "project_name" {
  description = "The name of the project in which to provision resources."
  type        = string
}

# The ID of the billing account to be linked to the new project.
# This is required to provision billable services like BigQuery.
variable "billing_account" {
  description = "The ID of the billing account to associate with the project."
  type        = string

}
