locals {
  env = "service"
  dev_terraform_tfvars = file("../dev/terraform.tfvars")
  dev_project_id = regex("project\\s*=\\s*\"([^\"]+)\"", local.dev_terraform_tfvars)[0]

  prod_terraform_tfvars = file("../prod/terraform.tfvars")
  prod_project_id = regex("project\\s*=\\s*\"([^\"]+)\"", local.prod_terraform_tfvars)[0]
}

resource "google_project_service" "required_apis" {
  project = var.project
  for_each = {
    "storage-api.googleapis.com"              = "Cloud Storage API"
    "cloudresourcemanager.googleapis.com"     = "Cloud Resource Manager API"
    "servicenetworking.googleapis.com"        = "Service Networking API"
    "cloudbuild.googleapis.com"               = "Cloud Build API"
    "iam.googleapis.com"                      = "Identity and Access Management (IAM) API"
  }
  service = each.key
  disable_on_destroy = false
}

data "google_project" "dev_project" {
  project_id = local.dev_project_id
}

data "google_project" "prod_project" {
  project_id = local.prod_project_id
}

resource "google_project_iam_member" "cloudbuild_owner_dev" {
  project = local.dev_project_id
  role    = "roles/owner"
  member  = "serviceAccount:${data.google_project.dev_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_owner_prod" {
  project = local.prod_project_id
  role    = "roles/owner"
  member  = "serviceAccount:${data.google_project.prod_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "cloudbuild_bucket_access" {
  bucket = google_storage_bucket.tfstate.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${var.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_storage_bucket" "tfstate" {
  project = var.project
  name          = "tfe-gitops-state"
  location      = "EU"
  force_destroy = true
}

resource "google_cloudbuild_trigger" "tfe_gitops_trigger" {
  project      = var.project
  description  = "CI/CD trigger for tfe-gitops repository"
  github {
    owner = var.github_repo_owner
    name  = var.github_repo_name
    push {
      branch = ".*"
    }
  }

  substitutions = {
    _BRANCH_NAME = "$BRANCH_NAME"
  }

  filename = "cloudbuild.yaml"

  # Workaround to send build logs to GitHub
  log_url_override = ""
}