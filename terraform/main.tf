provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "hello_world_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "hello_world_subnet" {
  vpc_id            = aws_vpc.hello_world_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
}

resource "aws_security_group" "hello_world_sg" {
  vpc_id = aws_vpc.hello_world_vpc.id

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
}

resource "aws_ecr_repository" "hello_world_app" {
  name = var.ecr_repository_name
}

resource "aws_ecs_cluster" "hello_world_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

resource "aws_ecs_task_definition" "hello_world_task" {
  family                   = "hello-world-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "hello-world-container"
      image     = "${aws_ecr_repository.hello_world_app.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
      ]
    }
  ])
}

resource "aws_ecs_service" "hello_world_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.hello_world_cluster.id
  task_definition = aws_ecs_task_definition.hello_world_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.hello_world_subnet.id]
    security_groups = [aws_security_group.hello_world_sg.id]
    assign_public_ip = true
  }
}

