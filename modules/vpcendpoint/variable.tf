
variable "vpc_id" {
  description = "VPC ID for Infra"
}

variable "route_table_id" {
  description = " Route table id of public subnet to connect S3 bucket"
}


/*
variable "subnets" {
  description = "Comma separated list of subnet IDs"
}

variable "vpc_id" {}

variable "security_groups" {
  description = "Comma separated list of security groups"
}

variable "mongouser" {
  
}
variable "mongopass" {
  
}
*/