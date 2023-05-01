output "private_network_admin_sa_email" {
  description = "The email address of the created private network admin service account."
  value       = google_service_account.private_network_admin_sa.email
}

output "private_network_admin_sa_key" {
  description = "The private key of the created private network admin service account in JSON format."
  value       = google_service_account_key.private_network_admin_sa_key.private_key
  sensitive   = true
}