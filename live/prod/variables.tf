variable "project_name" {
  description = "The name of the project. Used consistently for naming, tagging, and organizational purposes across resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment identifier (e.g., dev, staging, prod). Used for environment-specific tagging and naming."
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
