# 1. create public subnet in vpc with cidr block and tag
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.avail_zone, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
    tags = {
        Name: "${var.env_prefix}-publicsubnet-${format("%03d", count.index+1)}"
        SubnetType = "public"
    }
}
# create route table using internet gate way

resource "aws_route_table" "public_route_table" {
 vpc_id = var.vpc_id
 tags = {
     Name: "${var.env_prefix}-public-rt"
 }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.proj_igw.id
}

# create internet gateway for internet traffic in vpc
resource "aws_internet_gateway" "proj_igw" {
  vpc_id = var.vpc_id  
  tags = {
     Name: "${var.env_prefix}-igw"
 }
}

# create association for route traffic in subnet 

resource "aws_route_table_association" "public-rta" {
    count          = length(var.public_subnets)
    subnet_id      = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.avail_zone, count.index)
  count             = length(var.private_subnets)
  tags = {
        Name: "${var.env_prefix}-privatesubnet-${format("%03d", count.index+1)}"
        SubnetType = "private"
    }
}
# create route table for private subnet
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = var.vpc_id
  tags = {
      Name: "${var.env_prefix}-private-rt"
  }
}
# create association for route traffic in private subnet 

resource "aws_route_table_association" "private-rta" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# create elastic ip for NAT gateway to connect internet gateway

resource "aws_eip" "nat_eip" {
  count = length(var.private_subnets)
  vpc        = true
 // depends_on = [aws_internet_gateway.proj_igw]
 tags = {
    Name        = "${var.env_prefix}-nat-eip"
    }
}
# create NAT gateway in public subnet
resource "aws_nat_gateway" "main" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.proj_igw]
  tags = {
    Name        = "${var.env_prefix}-main-NAT"
  }
}
# create route to private subnet using NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "route_table" {
  
  value = aws_route_table.public_route_table.id
}