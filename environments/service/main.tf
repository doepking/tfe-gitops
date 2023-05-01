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

data "google_project" "service_project" {
  project_id = var.project
}

resource "google_project_iam_member" "cloudbuild_owner_dev" {
  project = local.dev_project_id
  role    = "roles/owner"
  member  = "serviceAccount:${data.google_project.service_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_owner_prod" {
  project = local.prod_project_id
  role    = "roles/owner"
  member  = "serviceAccount:${data.google_project.service_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_owner_service" {
  project = var.project
  role   = "roles/owner"
  member = "serviceAccount:${data.google_project.service_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_storage_bucket" "tfstate" {
  project = var.project
  name          = var.bucket_name
  location      = "EU"
  force_destroy = true
}

resource "google_cloudbuild_trigger" "tfe_gitops_trigger" {
  project      = var.project
  name  = "push-to-any-branch-cicd-trigger"
  description  = "Trigger to run CI/CD pipeline on any branch push"
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

  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
}