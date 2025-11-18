resource "aws_instance" "bastion" {
    ami = var.ami_id
    key_name = var.key_name
    instance_type = var.instance_type
    vpc_security_group_ids = [ var.security_group_id ]
    subnet_id = var.subnet_id

    tags = {
      Name = "Bastion"
    }
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}