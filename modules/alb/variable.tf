variable "env_prefix" {
  description = "Define tag name prefix for resources"
}

variable "subnets" {
  description = "Comma separated list of subnet IDs"
}

variable "vpc_id" {
  description = "VPC ID for Infra"
}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
}
variable "game_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}
