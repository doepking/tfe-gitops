terraform {
  backend "gcs" {
    bucket = "tfe-gitops-state"
    prefix = "env/prod"
  }
}
