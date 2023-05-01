variable "project_id" {
  type        = string
  description = "The ID of the project in which the resource belongs."
}

variable "secret_id" {
  description = "The ID of the secret to be created."
  type        = string
}

variable "payload_data" {
  description = "The data to be stored as a secret."
  type        = string
}