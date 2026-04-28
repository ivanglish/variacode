variable "environment_name" {
  description = "Environment name used in resource naming."
  type        = string
}

variable "env_label" {
  description = "Application environment label."
  type        = string
}

variable "container_port" {
  description = "Application container port."
  type        = number
}

variable "subnet_ids" {
  description = "Subnets for ECS task networking."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group attached to ECS tasks."
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN."
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "ECS task execution role ARN."
  type        = string
}
