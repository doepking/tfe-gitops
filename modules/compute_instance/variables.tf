variable "project_id" {
  description = "The project ID to host the VM instance"
  type        = string
}

variable "region" {
  description = "The region where the VM instance should be created"
  type        = string
}

variable "zone" {
  description = "The zone where the VM instance should be created"
  type        = string
}

variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
  default     = "vm-instance"
}

variable "machine_type" {
  description = "The machine type of the VM instance"
  type        = string
  default     = "e2-micro"
}

variable "ssh_user" {
  description = "The SSH username for the VM instance"
  type        = string
}

variable "ssh_key_pub" {
  description = "The public SSH key for the VM instance"
  type        = string
}

variable "private_key_pem" {
  description = "The private key in PEM format for SSH access to the instance"
  type        = string
}

variable "network_self_link" {
  description = "The self_link of the network"
  type        = string
}

variable "subnetwork_self_link" {
  description = "The self_link of the subnetwork"
  type        = string
}

variable "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  type        = string
}