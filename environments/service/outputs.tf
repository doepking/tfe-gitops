output "state_bucket_name" {
  value       = google_storage_bucket.tfstate.name
  description = "The name of the bucket used for storing Terraform state."
}

output "dev_project_id" {
  value       = local.dev_project_id
  description = "The project ID for the 'dev' environment."
}

output "prod_project_id" {
  value       = local.prod_project_id
  description = "The project ID for the 'prod' environment."
}

output "cloudbuild_trigger" {
  value = {
    id          = google_cloudbuild_trigger.tfe_gitops_trigger.id
    description = google_cloudbuild_trigger.tfe_gitops_trigger.description
    repo_name   = var.github_repo_name
    repo_owner  = var.github_repo_owner
  }
  description = "Information about the Cloud Build trigger for the tfe-gitops repository."
}

