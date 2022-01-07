

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  vpc_endpoint_type   = "Gateway"
  service_name = "com.amazonaws.ap-south-1.s3"
  route_table_ids  = [var.route_table_id]
  }
  
/*
terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "0.9.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

resource "mongodbatlas_database_user" "user" {
  username           = var.mongouser
  password           = var.mongopass
  project_id         = "61d2e8b11253821fe39a9cf7"
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "events"
  }

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }

  scopes {
    name = "events"
    type = "CLUSTER"
  }
}


resource "mongodbatlas_privatelink_endpoint" "private_endpoint" {
  project_id    = "61d2e8b11253821fe39a9cf7"
  provider_name = "AWS"
  region        = "ap-south-1"
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id             = var.vpc_id
  service_name       = mongodbatlas_privatelink_endpoint.private_endpoint.endpoint_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnets.*.id
  security_group_ids = var.security_groups
}

resource "mongodbatlas_privatelink_endpoint_service" "vpc_endpoint_service" {
  provider_name       = "AWS"
  project_id          = "61d2e8b11253821fe39a9cf7"
  private_link_id     = mongodbatlas_privatelink_endpoint.private_endpoint.private_link_id
  endpoint_service_id = aws_vpc_endpoint.vpc_endpoint.id
}
*/