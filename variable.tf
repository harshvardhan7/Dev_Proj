variable vpc_cidr_block{}
variable env_prefix {}
variable avail_zone {}
variable public_subnets{}
variable private_subnets{}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  default     = 2
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 8000
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/health"
}
/*
variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}*/