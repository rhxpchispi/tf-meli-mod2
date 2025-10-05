terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Simulación sin credenciales reales
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  access_key = "FAKE_KEY"
  secret_key = "FAKE_SECRET"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone

  # JSON "fake" válido para evitar el error de campo 'type'
  credentials = jsonencode({
    type             = "service_account"
    project_id       = var.gcp_project
    client_email     = "terraform@${var.gcp_project}.iam.gserviceaccount.com"
    auth_uri         = "https://accounts.google.com/o/oauth2/auth"
    token_uri        = "https://oauth2.googleapis.com/token"
    universe_domain  = "googleapis.com"
  })
}
