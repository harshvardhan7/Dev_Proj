variable env_prefix {}

variable "subnets" {
  description = "Comma separated list of subnet IDs"
}

variable "vpc_id" {}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
}
