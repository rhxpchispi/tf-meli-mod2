# Variables comunes para AWS y GCP

variable "aws_region" {
  description = "Región de AWS"
  type        = string
}

variable "gcp_project" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "gcp_region" {
  description = "Región de GCP"
  type        = string
}

variable "gcp_zone" {
  description = "Zona de GCP"
  type        = string
}
