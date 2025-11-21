variable "project_name" {
  description = "The name of the project. Used consistently for naming, tagging, and organizational purposes across resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment identifier (e.g., dev, staging, prod). Used for environment-specific tagging and naming."
  type        = string
}

# ========================
# 🌐 Networking Parameters
# ========================

variable "cidr_block" {
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16). Defines the IP address range for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for web public subnets"
  type        = list(string)
  default     = []
}

variable "frontend_private_subnets" {
  description = "CIDR blocks for web private subnets"
  type        = list(string)
  default     = []
}

variable "backend_private_subnets" {
  description = "CIDR blocks for app private subnets"
  type        = list(string)
  default     = []
}

variable "rds_allowed_ips" {
  description = "IP list for allowed IP address for RDS"
  type        = list(string)
  default     = []
}

variable "database_private_subnets" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Boolean flag to enable or disable the creation of a NAT Gateway. Requires at least one public subnet if set to true."
  type        = bool
  default     = false

  validation {
    condition     = !(var.enable_nat_gateway == true && length(var.public_subnets) == 0)
    error_message = "At least one public subnet is required when NAT Gateway is enabled."
  }
}