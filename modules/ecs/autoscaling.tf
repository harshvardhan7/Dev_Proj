
### ECS Autoscaling
resource "aws_appautoscaling_target" "target" {
  service_namespace = "ecs"
  resource_id = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity = 3
  max_capacity = 6
}
#Automatically scale capacity based on memory usage
resource "aws_appautoscaling_policy" "memory_usage" {
  name = "memory-auto-scaling"
  service_namespace = aws_appautoscaling_target.target.service_namespace
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  resource_id = aws_appautoscaling_target.target.resource_id
  policy_type = "TargetTrackingScaling" 
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification{
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }    
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.target]
}
#Automatically scale capacity based on CPU usage
resource "aws_appautoscaling_policy" "cpu_usage" {
  name = "cpu-auto-scaling"
  service_namespace = aws_appautoscaling_target.target.service_namespace
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  resource_id = aws_appautoscaling_target.target.resource_id
  policy_type = "TargetTrackingScaling" 
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification{
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    } 
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.target]
}
 # CloudWatch alarm that triggers the autoscaling up policy

resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name = "myapp_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "60"
  statistic = "Average"
  threshold = "80" 
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.ecs_service.name
  } 
  alarm_actions = [aws_appautoscaling_policy.cpu_usage.arn]
}
# CloudWatch alarm that triggers the autoscaling down policy

resource "aws_cloudwatch_metric_alarm" "service_memory_high" {
  alarm_name = "myapp_memory_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "MemoryUtilization"
  namespace = "AWS/ECS"
  period = "60"
  statistic = "Average"
  threshold = "80" 
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.ecs_service.name
    } 
  alarm_actions = [aws_appautoscaling_policy.memory_usage.arn]
}

