variable vpc_cidr_block{}
variable env_prefix {}
variable avail_zone {}
variable public_subnets{}
variable private_subnets{}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  default     = 3
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 80
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "region" {}

#variable "mongouser" {}
#variable "mongopass" {}