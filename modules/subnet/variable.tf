
variable "env_prefix" {
  description = "Define tag name prefix for resources"
}
variable "vpc_id" {
  description = "VPC ID for Infra"
}

variable avail_zone {
    description = "Availabilty zone for subnets"
}

variable private_subnets {
    description = "CIDR Block for private subnet"
}

variable public_subnets {
    description = "CIDR Block for public subnet"
}