variable "environment" {
  description = "Target environment name (test or prod). If empty, workspace is used."
  type        = string
  default     = ""
}

variable "environments" {
  description = "Environment-specific configuration map."
  type = map(object({
    env_label      = string
    container_port = number
    vpc_cidr       = string
    subnet_cidr_1  = string
    subnet_cidr_2  = string
    source_branch  = string
    pr_trigger     = bool
  }))

  default = {
    test = {
      env_label      = "testing"
      container_port = 80
      vpc_cidr       = "10.0.0.0/16"
      subnet_cidr_1  = "10.0.1.0/24"
      subnet_cidr_2  = "10.0.2.0/24"
      source_branch  = "test"
      pr_trigger     = false
    }
    prod = {
      env_label      = "production"
      container_port = 80
      vpc_cidr       = "10.1.0.0/16"
      subnet_cidr_1  = "10.1.1.0/24"
      subnet_cidr_2  = "10.1.2.0/24"
      source_branch  = "main"
      pr_trigger     = true
    }
  }
}