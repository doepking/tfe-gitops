output "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.mysql.connection_name
}

output "instance_self_link" {
  description = "The self link of the Cloud SQL instance"
  value       = google_sql_database_instance.mysql.self_link
}

output "db_password" {
  value       = random_password.db_password.result
  description = "Generated random password for the database user"
  sensitive   = true
}