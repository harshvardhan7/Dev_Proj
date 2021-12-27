### ECS Cluster Setup

#create a cluster named ecs_cluster
resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.ecs-cluster-name
}

#create ECS task definition
resource "aws_ecs_task_definition" "ecs_task_definition"{
    family                   = "BT-Microservices"
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    container_definitions    = data.template_file.app.rendered
}

#create ECS service
resource "aws_ecs_service" "ecs_service" {
    name            = "app-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task_definition.arn
    desired_count   = var.app_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = var.security_group
        subnets          = var.subnets.*.id
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = var.aws_alb_target_group_arn
        container_name   = "app"
        container_port   = var.app_port
    }

    depends_on = [var.alb_listener,
                   aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}