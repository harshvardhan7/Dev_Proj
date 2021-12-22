# 1. create public subnet in vpc with cidr block and tag
resource "aws_subnet" "public_subnet1" {
    vpc_id = var.vpc_id
    cidr_block = var.publicsubnet1_cidr_block
    availability_zone = var.avail_zone1
    map_public_ip_on_launch = true
    tags = {
        Name: "${var.env_prefix}-publicsubnet-1"
        SubnetType = "public"
    }
  
}
resource "aws_subnet" "public_subnet2" {
    vpc_id = var.vpc_id
    cidr_block = var.publicsubnet2_cidr_block
    availability_zone = var.avail_zone2
    map_public_ip_on_launch = true
    tags = {
        Name: "${var.env_prefix}-publicsubnet-2"
        SubnetType = "public"
    }
  
}

# create route table using internet gate way

resource "aws_route_table" "my_route_table" {
 vpc_id = var.vpc_id
 route {
     cidr_block = "0.0.0.0/0" # define all traffic 
     gateway_id = aws_internet_gateway.proj_igw.id
 }
 tags = {
     Name: "${var.env_prefix}-rt"
 }
}
# create internet gateway for internet traffic in vpc
resource "aws_internet_gateway" "proj_igw" {
  vpc_id = var.vpc_id  
  tags = {
     Name: "${var.env_prefix}-igw"
 }
}

# create association for route traffic in subnet 

resource "aws_route_table_association" "a-rtb-subnet1" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.my_route_table.id
}
resource "aws_route_table_association" "a-rtb-subnet2" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.my_route_table.id

}

# 2. create private subnet in vpc with cidr block and tag
resource "aws_subnet" "private_subnet1" {
    vpc_id = var.vpc_id
    cidr_block = var.privatesubnet1_cidr_block
    availability_zone = var.avail_zone1
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-privatesubnet-1"
        SubnetType = "private"
    }
  
}
resource "aws_subnet" "private_subnet2" {
    vpc_id = var.vpc_id
    cidr_block = var.privatesubnet2_cidr_block
    availability_zone = var.avail_zone2
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-privatesubnet-2"
        SubnetType = "private"
    }
  
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
      Name: "${var.env_prefix}-privaterRTB"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private2" {
  subnet_id     = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat_eip1" {
  vpc        = true
  depends_on = [aws_internet_gateway.proj_igw]
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on    = [aws_internet_gateway.proj_igw]
  tags = {
    Name        = "${var.env_prefix}-nat1"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat1.id
}