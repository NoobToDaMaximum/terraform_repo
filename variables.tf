variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "project_name" {
  description = "The name of the project in which to provision resources."
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate with the project."
  type        = string

}