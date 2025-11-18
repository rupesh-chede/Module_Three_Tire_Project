
variable "vpc_cidr" {
    description = "vpc cidr"
    type = string
    default = ""  
}

variable "vpc_name" {
    description = "vpc name"
    type = string
    default = ""
}

####----subnets-----####

variable "public_sub_1_cidr" {
    type = string
}

variable "public_sub_2_cidr" {
    type = string
}

variable "private_sub_1_cidr" {
    type = string
}

variable "private_sub_2_cidr" {
    type = string
}

variable "private_sub_3_cidr" {
    type = string
}

variable "private_sub_4_cidr" {
    type = string
}

variable "private_sub_5_cidr" {
    type = string
}

variable "private_sub_6_cidr" {
    type = string
}



variable "vpc_id" {
    description = "VPC ID where security groups will be created"
    type = string
}

variable "allowed_ssh_cidr" {
    description = "cidr block allowed ssh cidr"
    type = list(string)
    default = [ "0.0.0.0/0" ]
}