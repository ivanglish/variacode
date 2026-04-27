resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/webpage-${local.environment_name}"
  retention_in_days = 7

  tags = {
    name = "csgtest"
  }
}


resource "aws_ecs_cluster" "main" {
  name = "app-cluster-${local.environment_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    name = "csgtest"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "my-app-${local.environment_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn



  container_definitions = jsonencode([
    {
      name      = "webpage"
      image     = "967696262685.dkr.ecr.sa-east-1.amazonaws.com/variacode:latest"
      essential = true

      portMappings = [
        {
          containerPort = local.env_config.container_port
          hostPort      = local.env_config.container_port
        }
      ]

      environment = [
        {
          name  = "APP_ENV"
          value = local.env_config.env_label
        },
        {
          name  = "WORKSPACE"
          value = local.environment_name
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
  name            = "webpage-service-${local.environment_name}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "webpage"
    container_port   = local.env_config.container_port
  }

  network_configuration {
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }
  # Ensure the LB is created BEFORE the service tries to use it
  depends_on = [aws_lb_listener.http]

  tags = {
    name = "csgtest"
  }
}