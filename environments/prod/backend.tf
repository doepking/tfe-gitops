terraform {
  backend "gcs" {
    bucket = "genial-runway-383808-tfstate"
    prefix = "env/prod"
  }
}
