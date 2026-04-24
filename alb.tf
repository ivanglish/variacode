# The Application Load Balancer
resource "aws_lb" "main" {
  name               = "web-alb-${terraform.workspace}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    name = "csgtest"
  }
}

# The Target Group
resource "aws_lb_target_group" "app" {
  name        = "tg-${terraform.workspace}"
  port        = lookup(var.container_port, terraform.workspace)
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.existing.id
  target_type = "ip"

  tags = {
    name = "csgtest"
  }

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# The Listener (Forwarding traffic to the Target Group)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    name = "csgtest"
  }
}