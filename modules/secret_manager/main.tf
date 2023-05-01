resource "google_secret_manager_secret" "secret" {
  project = var.project_id
  secret_id = var.secret_id
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.payload_data
}
