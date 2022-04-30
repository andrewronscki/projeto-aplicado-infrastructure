resource "aws_ecs_cluster" "this" {
  name = "contree-prod"

  tags = merge(local.common_tags, { Name = "Cluster ECS Projeto Aplicado" })
}

resource "aws_ecr_repository" "this" {
  name                 = "contree-repository"

  tags = merge(local.common_tags, { Name = "Repository ECR Projeto Aplicado" })
}

data "template_file" "this" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    host_port      = var.host_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "contree-td"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.this.rendered
}

resource "aws_ecs_service" "this" {
  name            = "contree-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.pvt_a.id, aws_subnet.pvt_b.id]
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "contree-server"
    container_port   = var.app_port
  }

  health_check_grace_period_seconds = 30

  tags = merge(local.common_tags, { Name = "Service ECS Projeto Aplicado" })
}

# ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
