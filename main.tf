module "networking" {
  source = "./networking"

  environment_name = local.environment_name
  vpc_cidr         = local.env_config.vpc_cidr
  subnet_cidr_1    = local.env_config.subnet_cidr_1
  subnet_cidr_2    = local.env_config.subnet_cidr_2
  container_port   = local.env_config.container_port
}

module "ecs" {
  source = "./ecs"

  environment_name        = local.environment_name
  env_label               = local.env_config.env_label
  container_port          = local.env_config.container_port
  subnet_ids              = module.networking.subnet_ids
  ecs_security_group_id   = module.networking.ecs_security_group_id
  target_group_arn        = module.networking.target_group_arn
  ecs_execution_role_arn  = module.networking.ecs_execution_role_arn
}

module "deployment_infrastructure" {
  source = "./pipelines"

  environment   = local.environment_name
  env_label     = local.env_config.env_label
  source_branch = local.env_config.source_branch
  pr_trigger    = local.env_config.pr_trigger
}