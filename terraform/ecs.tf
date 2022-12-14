data "aws_region" "current" {}

# Create ECS Cluster
resource "aws_ecs_cluster" "lamp" {
  name = "lamp"
}

# Create ECS Task Definition
resource "aws_ecs_task_definition" "lamp_web" {
  family                   = "lamp-web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_web.arn
  container_definitions = jsonencode([{
    name      = "web"
    image     = "${var.img_uri}"
    essential = true
    portMappings = [
      {
        containerPort = 80
        protocol      = "tcp"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.lamp.name
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = "web"
      }
    }
  }])
}

resource "aws_ecs_service" "lamp_web" {
  name                               = "lamp-web"
  cluster                            = aws_ecs_cluster.lamp.id
  task_definition                    = aws_ecs_task_definition.lamp_web.arn
  desired_count                      = 4
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.lamp_web.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.lamp_web.arn
    container_name   = "web"
    container_port   = 80
  }
}

resource "aws_cloudwatch_log_group" "lamp" {
  name = "/fargate/service/lamp"
}
