terraform {
  required_version = "~> 1.4.4"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }
  }
}