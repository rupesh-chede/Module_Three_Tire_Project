output "vpc_id" {
    value = aws_vpc.three_tire.id  
}

output "public_subnets" {
    value = [aws_subnet.sub_1.id , aws_subnet.sub_2.id]
}

output "private_web_subnets" {
    value = [aws_subnet.sub_3.id , aws_subnet.sub_4.id]
}

output "private_app_subnet" {
    value = [aws_subnet.sub_5.id , aws_subnet.sub_6.id]
}

output "database_subnets" {
    value = [aws_subnet.sub_7.id , aws_subnet.sub_8.id]
  
}

output "bastion_sg_id" {
  description = "ID of the Bastion Host SG"
  value       = aws_security_group.bastion_host.id
}

output "alb_frontend_sg_id" {
  description = "ID of the Frontend ALB SG"
  value       = aws_security_group.alb_frontend.id
}

output "alb_backend_sg_id" {
  description = "ID of the Backend ALB SG"
  value       = aws_security_group.alb_backend.id
}

output "frontend_server_sg_id" {
  description = "ID of the Frontend Server SG"
  value       = aws_security_group.frontend_server.id
}

output "backend_server_sg_id" {
  description = "ID of the Backend Server SG"
  value       = aws_security_group.backend_server.id
}

output "database_sg_id" {
  description = "ID of the Database SG"
  value       = aws_security_group.database.id
}