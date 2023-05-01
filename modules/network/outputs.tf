output "private_network_self_link" {
  description = "The self link of the private network"
  value       = google_compute_network.private_network.self_link
}

output "private_vpc_connection" {
  description = "The private VPC connection for the Cloud SQL instance"
  value       = google_service_networking_connection.private_vpc_connection.id
}

output "network_cidr" {
  description = "The CIDR of the created subnetwork"
  value       = google_compute_subnetwork.private_subnetwork.ip_cidr_range
}

output "subnetwork_self_link" {
  description = "The self link of the private subnetwork"
  value       = google_compute_subnetwork.private_subnetwork.self_link
}