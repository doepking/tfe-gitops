variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region where the subnet should be created"
  type        = string
}

variable "network_name" {
  description = "The name of the private network"
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account used for Terraform."
  type        = string
}