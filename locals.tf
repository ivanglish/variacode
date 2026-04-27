locals {
  environment_name = var.environment != "" ? var.environment : terraform.workspace
  env_config       = var.environments[local.environment_name]
}
