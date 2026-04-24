output "ecs_service_name" {
  value = aws_ecs_service.main.name
}

output "subnet_ids" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}

output "alb_dns_name" {
  description = "The permanent URL for your application"
  value       = "http://${aws_lb.main.dns_name}"
}