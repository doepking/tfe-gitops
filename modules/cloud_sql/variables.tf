variable "project_id" {
  description = "The project ID where the Cloud SQL instance will be created"
  type        = string
}

variable "region" {
  description = "The region where the Cloud SQL instance will be created"
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
  description = "The name of the Cloud SQL database"
  type        = string
}

variable "db_user_name" {
  description = "The username for the database"
  type        = string
}

variable "private_network_self_link" {
  description = "The self_link of the private network"
  type        = string
}

variable "private_vpc_connection" {
  description = "The private VPC connection for the Cloud SQL instance"
  type        = string
}

variable "enable_backup" {
  description = "Enable automated backups of the Cloud SQL instance"
  type        = bool
}

variable "deletion_protection" {
  description = "Enable or disable deletion protection for the Cloud SQL instance."
  type        = bool
  default     = false
}

variable "vm_instance_network" {
  description = "The network CIDR from which the VM instance can connect to the Cloud SQL instance"
  type        = string
}