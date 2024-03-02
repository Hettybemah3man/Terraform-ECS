# --- ECS Cluster ---

resource "aws_ecs_cluster" "great" {
  name = "great-cluster"
}

# --- ECS Node Role ---

data "aws_iam_policy_document" "ecs_node_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_node_role" {
  name_prefix        = "great-ecs-node-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_node_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_node_role_policy" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}



#Execution role
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_ecs_task_definition" "nginxdemos_task" {
  family = "nginxdemos"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = "256"
  memory = "512"

execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx-container"
      image     = "nginxdemos/hello"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },

  ])

} 

resource "aws_ecs_service" "great_service" {
  name            = "great-service"
  cluster         = aws_ecs_cluster.great.id
  task_definition = aws_ecs_task_definition.nginxdemos_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = [aws_subnet.great_pub_sub_1.id, aws_subnet.great_pub_sub_2.id]
    assign_public_ip = true 
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.great_tg.arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  depends_on = [aws_alb_listener.front_end]
}  