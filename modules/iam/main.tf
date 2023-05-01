resource "google_service_account" "private_network_admin_sa" {
  project      = var.project_id
  account_id   = "private-network-admin"
  display_name = "Private Network Admin"
}

resource "google_service_account_key" "private_network_admin_sa_key" {
  service_account_id = google_service_account.private_network_admin_sa.name
}

resource "google_project_iam_member" "networks_admin" {
  project = var.project_id
  role    = "roles/servicenetworking.networksAdmin"
  member  = "serviceAccount:${google_service_account.private_network_admin_sa.email}"
}
