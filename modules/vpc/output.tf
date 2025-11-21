output "id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = try(aws_subnet.public[*].id, [])
}

output "frontend_private_subnets" {
  value = try(aws_subnet.frontend_private[*].id, [])
}

output "backend_private_subnets" {
  value = try(aws_subnet.backend_private[*].id, [])
}

output "database_private_subnets" {
  value = try(aws_subnet.database_private[*].id, [])
}

output "frontend_sg" {
  value = aws_security_group.frontend.id
}

output "backend_sg" {
  value = aws_security_group.backend.id
}

output "alb_sg" {
  value = aws_security_group.alb.id
}

output "rds_sg" {
  value = aws_security_group.rds.id
}