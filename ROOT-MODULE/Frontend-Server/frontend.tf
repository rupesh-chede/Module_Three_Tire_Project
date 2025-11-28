resource "aws_instance" "frontend" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.frontend_instance_type
    subnet_id = var.frontend_sub_1
    vpc_security_group_ids = [ var.frontend_sg_id ]
    availability_zone = "us-east-1a"
    key_name = "test"

    tags = {
      Name = "Frontend server"
    }
  
}