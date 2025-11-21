# ==================
# General Deployment
# ==================
variable "project_name" {
  type        = string
  description = "Base name used to prefix ECS service, tasks, and related resources."
}

variable "name" {
  type        = string
  description = "Name of the ECS service. Commonly used as the service identity within the project."
}

variable "environment" {
  type        = string
  description = "Deployment environment identifier (e.g., dev, staging, prod)."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs in which the ECS service tasks will run."
}

variable "security_groups" {
  type        = list(string)
  description = "List of security group IDs to attach to the ECS service tasks."
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "Desired number of ECS task instances to run for the service."
}

variable "capacity_provider_name" {
  type        = string
  default     = null
  description = "Optional ECS capacity provider name. When set, the service runs using that capacity provider."
}

variable "cpu_scaling_target_value" {
  type        = string
  default     = null
  description = "Target CPU utilization percentage for ECS auto scaling (e.g., 70)."
}

variable "memory_scaling_target_value" {
  type        = string
  default     = null
  description = "Target memory utilization percentage for ECS auto scaling (e.g., 80)."
}

variable "enable_code_deploy" {
  type        = string
  default     = false
  description = "Enable AWS CodeDeploy for blue/green deployment strategy when set to true."
}

variable "health_check_grace_period_seconds" {
  type        = number
  default     = null
  description = "Optional grace period for the ECS service to pass health checks after launching a new task."
}

variable "container_name" {
  type        = string
  description = "Name of the container definition that the ECS service should target."
}

variable "task_definition_arn" {
  type        = string
  description = "ARN of the ECS task definition to run for the service."
}

variable "alb_blue_tg_arn" {
  type        = string
  description = "ARN of the ALB target group used for blue/green deployments."
}

variable "container_port" {
  type        = number
  description = "Port exposed by the container that the ECS service should route traffic to."
}

# ========================
# ECS Cluster
# ========================
variable "ecs_cluster_id" {
  type        = string
  description = "ID of the ECS cluster where the service will be deployed."
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster where the service will run."
}
