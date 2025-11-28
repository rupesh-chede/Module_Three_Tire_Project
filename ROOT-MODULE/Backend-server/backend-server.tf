resource "aws_instance" "frontend" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.backend_instance_type
    subnet_id = var.backend_sub_1
    vpc_security_group_ids = [ var.backend_sg_id ]
    availability_zone = "us-east-1a"
    key_name = "test"

    tags = {
      Name = "Backend server"
    }
  
}