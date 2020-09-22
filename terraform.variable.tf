
variable "project_id" {
  description = "Project ID in GCP"
  type = string
}

variable "project_name" {
  type = string
  description = "Project name in GCP"
}

variable "project_region" {
  type = string
  description = "Region in which to manage GCP resources"
}

variable "project_billing_account_id" {
  type = string
  description = "Billing ID GCP"
}

variable "project_root_email" {}
variable "project_cto_email" {}
variable "function_name" {}
variable "function_entrypoint" {}
variable "function_description" {}
variable "function_path" {}
variable "function_runtime" {}
variable "function_bucket_name" {}

