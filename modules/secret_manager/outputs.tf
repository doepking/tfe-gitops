output "secret_id" {
  description = "The ID of the created secret in Google Secret Manager"
  value       = google_secret_manager_secret.secret.id
}

output "secret_version" {
  description = "The version of the created secret in Google Secret Manager"
  value       = google_secret_manager_secret_version.secret_version.id
}