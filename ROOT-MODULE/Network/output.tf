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