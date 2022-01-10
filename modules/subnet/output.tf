output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "route_table" {
  
  value = aws_route_table.public_route_table.id
}