resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/webpage-${var.environment_name}"
  retention_in_days = 7

  tags = {
    name = "csgtest"
  }
}

resource "aws_ecs_cluster" "main" {
  name = "app-cluster-${var.environment_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    name = "csgtest"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "my-app-${var.environment_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "webpage"
      image     = "967696262685.dkr.ecr.sa-east-1.amazonaws.com/variacode:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]

      environment = [
        {
          name  = "APP_ENV"
          value = var.env_label
        },
        {
          name  = "WORKSPACE"
          value = var.environment_name
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = "sa-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    name = "csgtest"
  }
}

resource "aws_ecs_service" "main" {
  name            = "webpage-service-${var.environment_name}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "webpage"
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = [var.ecs_security_group_id]
  }

  tags = {
    name = "csgtest"
  }
}
