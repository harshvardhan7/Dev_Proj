variable "env_prefix" {
  description = "Define tag name prefix for resources"
}
variable "vpc_id" {
  description = "VPC ID for Infra"
}

variable "container_port" {
  description = "Ingres and egress port of the container"
}