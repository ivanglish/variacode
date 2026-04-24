module "deployment_infrastructure" {
  source = "./pipelines"

  # Pass the context into the module variables
  workspace_name = terraform.workspace
  env_label      = lookup(var.envs, terraform.workspace)
}