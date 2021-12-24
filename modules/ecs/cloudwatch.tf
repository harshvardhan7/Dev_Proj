resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.env_prefix}-task"

  tags = {
    Name        = "${var.env_prefix}-task"
    
  }
}