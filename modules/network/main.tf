resource "google_compute_network" "private_network" {
  project = var.project_id
  name = var.network_name
}

resource "google_compute_subnetwork" "private_subnetwork" {
  project       = var.project_id
  name          = "${var.network_name}-subnetwork"
  network       = google_compute_network.private_network.self_link
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
}


resource "google_compute_global_address" "private_ip_address" {
  project = var.project_id
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_project_iam_member" "networks_admin" {
  project = var.project_id
  role    = "roles/servicenetworking.networksAdmin"
  member  = "serviceAccount:${var.service_account_email}"
}