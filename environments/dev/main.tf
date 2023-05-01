locals {
  env = var.environment
}

resource "google_project_service" "required_apis" {
  project = var.project
  for_each = {
    "sqladmin.googleapis.com"                 = "Cloud SQL Admin API"
    "compute.googleapis.com"                  = "Compute Engine API"
    "cloudresourcemanager.googleapis.com"     = "Cloud Resource Manager API"
    "servicenetworking.googleapis.com"        = "Service Networking API"
    "cloudbuild.googleapis.com"               = "Cloud Build API"
    "iam.googleapis.com"                      = "Identity and Access Management (IAM) API"
    "secretmanager.googleapis.com"            = "Secret Manager API"
  }
  service = each.key
  disable_on_destroy = false
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "secret_manager" {
  project_id   = var.project
  source       = "../../modules/secret_manager"
  secret_id    = "vm-ssh-private-key"
  payload_data = tls_private_key.ssh_key.private_key_pem
}

module "cloud_sql" {
  source = "../../modules/cloud_sql"
  project_id                = var.project
  region                    = var.region
  instance_name             = var.instance_name
  instance_tier             = var.instance_tier
  database_name             = var.database_name
  db_user_name              = var.db_user_name
  private_network_self_link = module.network.private_network_self_link
  private_vpc_connection    = module.network.private_vpc_connection
  vm_instance_network       = module.network.network_cidr
  enable_backup             = true
  deletion_protection       = false
}

module "db_password_secret" {
  source       = "../../modules/secret_manager"
  project_id   = var.project
  secret_id    = "db-password"
  payload_data = module.cloud_sql.db_password
}

module "network" {
  source                = "../../modules/network"
  project_id            = var.project
  region                = var.region
  network_name          = var.network_name
  service_account_email = module.iam.private_network_admin_sa_email
}

module "iam" {
  source = "../../modules/iam"
  project_id   = var.project
  network_name = var.network_name
}

module "compute_instance" {
  source                   = "../../modules/compute_instance"
  project_id               = var.project
  region                   = var.region
  zone                     = var.zone
  ssh_user                 = var.ssh_user
  ssh_key_pub              = tls_private_key.ssh_key.public_key_openssh
  private_key_pem          = tls_private_key.ssh_key.private_key_pem
  network_self_link        = module.network.private_network_self_link
  subnetwork_self_link     = module.network.subnetwork_self_link
  instance_connection_name = module.cloud_sql.instance_connection_name
}