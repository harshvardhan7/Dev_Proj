
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

module "project_subnet" {

    source = "./modules/subnet"
    publicsubnet1_cidr_block = var.publicsubnet1_cidr_block
    publicsubnet2_cidr_block = var.publicsubnet2_cidr_block
    privatesubnet1_cidr_block = var.privatesubnet1_cidr_block
    privatesubnet2_cidr_block = var.privatesubnet2_cidr_block
    avail_zone1 = var.avail_zone1
    avail_zone2 = var.avail_zone2
    vpc_id = aws_vpc.projectvpc.id
    env_prefix = var.env_prefix

}

module "ecs_application" {

    source = "./modules/application"
    
    avail_zone1 = var.avail_zone1
    vpc_id = aws_vpc.projectvpc.id
    env_prefix = var.env_prefix

}