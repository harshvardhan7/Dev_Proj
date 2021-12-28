
provider "aws" {
    region = "ap-south-1"
}


# 1. create vpc with cidr block and tag  
resource "aws_vpc" "projectvpc" {
cidr_block = var.vpc_cidr_block
tags = {
    Name: "${var.env_prefix}-vpc"
}

}

#define subnet module

module "subnet" {

    source = "./modules/subnet"

    private_subnets    = var.private_subnets
    public_subnets     = var.public_subnets
    avail_zone = var.avail_zone
    vpc_id = aws_vpc.projectvpc.id
    env_prefix = var.env_prefix

}
#define security group module

module "security_groups" {
  source         = "./modules/security-groups"
  vpc_id         = aws_vpc.projectvpc.id
  env_prefix     = var.env_prefix
  container_port = var.container_port
}
#define Application Load Balancer module
module "alb" {
  source              = "./modules/alb"
  vpc_id              = aws_vpc.projectvpc.id
  subnets             = module.subnet.public_subnets
  env_prefix          = var.env_prefix
  alb_security_groups = [module.security_groups.alb]
 // alb_tls_cert_arn    = var.tsl_certificate_arn
 //health_check_path   = var.health_check_path
}

module "ecs" {
  source                      = "./modules/ecs"
  subnets                     = module.subnet.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  alb_listener                = module.alb.alb_listener
  security_group              = [module.security_groups.ecs_tasks]
  env_prefix                  = var.env_prefix
  ecr_repo_region             = var.region
 /*
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port }
  ]
  container_secrets      = module.secrets.secrets_map
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
  container_secrets_arns = module.secrets.application_secrets_arn*/
}