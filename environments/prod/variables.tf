variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the resources"
  type        = string
}

variable "zone" {
  description = "The GCP zone for the resources"
  type        = string
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
}

variable "instance_tier" {
  description = "The tier of the Cloud SQL instance"
  type        = string
}

variable "database_name" {
  description = "The name of the database to be created in the Cloud SQL instance"
  type        = string
}

variable "db_user_name" {
  description = "The username for the database"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "ssh_user" {
  description = "The SSH username for the VM instance"
  type        = string
}