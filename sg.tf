# Security Group for the Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg-${terraform.workspace}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "csgtest"
  }
}

# Security Group to allow Web Traffic
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-web-sg-${terraform.workspace}"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = lookup(var.container_port, terraform.workspace)
    to_port     = lookup(var.container_port, terraform.workspace)
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = lookup(var.container_port, terraform.workspace)
    to_port         = lookup(var.container_port, terraform.workspace)
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "csgtest"
  }
}