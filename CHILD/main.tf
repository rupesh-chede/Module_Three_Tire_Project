provider "aws" {
    region = "us-east-1"
  
}

module "network" {
    source = "../ROOT-MODULE/Network"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "project"
    public_sub_1_cidr = "10.0.1.0/24"
    public_sub_2_cidr = "10.0.2.0/24"
    private_sub_1_cidr = "10.0.3.0/24"
    private_sub_2_cidr = "10.0.4.0/24"
    private_sub_3_cidr = "10.0.5.0/24"
    private_sub_4_cidr = "10.0.6.0/24"
    private_sub_5_cidr = "10.0.7.0/24"
    private_sub_6_cidr = "10.0.8.0/24"
    vpc_id = module.network.vpc_id
    allowed_ssh_cidr = ["0.0.0.0/0"]
  
}