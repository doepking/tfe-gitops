output "cloud_sql_instance_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = module.cloud_sql.instance_connection_name
}

output "cloud_sql_instance_self_link" {
  description = "The self link of the Cloud SQL instance"
  value       = module.cloud_sql.instance_self_link
}

output "private_network_self_link" {
  description = "The self link of the private network"
  value       = module.network.private_network_self_link
}

output "instance_external_ip" {
  description = "The external IP address of the VM instance in the dev environment"
  value       = module.compute_instance.instance_external_ip
}

output "instance_self_link" {
  description = "The self-link of the VM instance in the dev environment"
  value       = module.compute_instance.instance_self_link
}

output "db_password_secret_id" {
  description = "The ID of the Secret Manager secret containing the database password"
  value       = module.db_password_secret.secret_id
}

output "db_password_secret_version" {
  description = "The version of the Secret Manager secret containing the database password"
  value       = module.db_password_secret.secret_version
}