variable "environment_name" {
  description = "Environment name used in resource naming."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "subnet_cidr_1" {
  description = "CIDR for public subnet 1."
  type        = string
}

variable "subnet_cidr_2" {
  description = "CIDR for public subnet 2."
  type        = string
}

variable "container_port" {
  description = "Application container port."
  type        = number
}
