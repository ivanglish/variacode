output "ecs_service_name" {
  value = module.ecs.ecs_service_name
}

output "subnet_ids" {
  value = module.networking.subnet_ids
}

output "security_group_id" {
  value = module.networking.ecs_security_group_id
}

output "alb_dns_name" {
  description = "The permanent URL for your application"
  value       = "http://${module.networking.alb_dns_name}"
}