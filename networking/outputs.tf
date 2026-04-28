output "subnet_ids" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}
