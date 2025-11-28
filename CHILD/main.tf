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

module "bastion" {
    source = "../ROOT-MODULE/Bastion"
    ami_id = "ami-00ca32bbc84273381"
    instance_type = "t3.micro"
    key_name = "test"
    subnet_id = module.network.public_subnets[0]
    security_group_id = module.network.bastion_sg_id
  
}

module "rds" {
    source = "../ROOT-MODULE/rds"
    project_name = "three_tire"
    identifier = "book-rds"
    allocated_storage = 20
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    multi_az = false
    db_name = "bookdb"
    db_username = "admin"
    db_password = "SkyOps123"
    db_subnet_1_id = module.network.database_subnets[0]
    db_subnet_2_id = module.network.database_subnets[1]
    rds_sg_id = module.network.database_sg_id
  
}

module "frontend" {
    source = "../ROOT-MODULE/Frontend-Server"
    frontend_instance_type = "c7i-flex.large"
    frontend_sub_1 = module.network.private_web_subnets[0]
    frontend_sg_id = module.network.frontend_server_sg_id
    

}

module "backend-server" {
    source = "../ROOT-MODULE/Backend-server"
    backend_instance_type = "c7i-flex.large"
    backend_sub_1 =  module.network.private_app_subnet[0]
    backend_sg_id =  module.network.backend_server_sg_id

}