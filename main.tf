module "deployment_infrastructure" {
  source = "./pipelines"

  environment   = local.environment_name
  env_label     = local.env_config.env_label
  source_branch = local.env_config.source_branch
  pr_trigger    = local.env_config.pr_trigger
}