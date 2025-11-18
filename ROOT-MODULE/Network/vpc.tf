resource "aws_vpc" "three_tire" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = var.vpc_name
    }
  
}

#____________public subnets___________#

resource "aws_subnet" "sub_1" {
    cidr_block = var.public_sub_1_cidr
    vpc_id = aws_vpc.three_tire.id
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.vpc_name}-public-subnet-1"
    }
}

resource "aws_subnet" "sub_2" {
    cidr_block = var.public_sub_2_cidr
    vpc_id = aws_vpc.three_tire.id
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.vpc_name}-public-subnet-2"
    }
}


#_____________private subnets________________

resource "aws_subnet" "sub_3" {
    vpc_id = aws_vpc.three_tire.id
    cidr_block = var.private_sub_1_cidr
    availability_zone = "us-east-1a"

    tags = {
      Name = "${var.vpc_name}-private-web-1"
    }
}

resource "aws_subnet" "sub_4" {
    vpc_id = aws_vpc.three_tire.id
    cidr_block = var.private_sub_2_cidr
    availability_zone = "us-east-1b"

    tags = {
      Name = "${var.vpc_name}-private-web-2"
    }
}

resource "aws_subnet" "sub_5" {
    vpc_id = aws_vpc.three_tire.id
    cidr_block = var.private_sub_3_cidr
    availability_zone = "us-east-1a"

    tags = {
      Name = "${var.vpc_name}-private-app-1"
    }
}

resource "aws_subnet" "sub_6" {
    vpc_id = aws_vpc.three_tire.id
    cidr_block = var.private_sub_4_cidr
    availability_zone = "us-east-1b"

    tags = {
      Name = "${var.vpc_name}-private-app-2"
    }
}

resource "aws_subnet" "sub_7" {
    vpc_id = aws_vpc.three_tire.id
    cidr_block = var.private_sub_5_cidr
    availability_zone = "us-east-1a"

    tags = {
      Name = "${var.vpc_name}-private-rds-1"
    }
}

resource "aws_subnet" "sub_8" {
    vpc_id = aws_vpc.three_tire.id
    cidr_block = var.private_sub_6_cidr
    availability_zone = "us-east-1b"

    tags = {
      Name = "${var.vpc_name}-private-rds-2"
    }
}


#___________IG and route table__________

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.three_tire.id

    tags = {
      Name = "${var.vpc_name}-igw"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.three_tire.id
    tags = {
      Name = "${var.vpc_name}-public-rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_asso" {
    for_each = {
        pub1 = aws_subnet.sub_1.id
        pub2 = aws_subnet.sub_2.id
    }
    subnet_id = each.value
    route_table_id = aws_route_table.public_rt.id
}

#_______________NAT gtw and Private rt___________
resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat_gtw" {
    subnet_id = aws_subnet.sub_1.id
    allocation_id = aws_eip.nat_eip.id
    connectivity_type = "public"

    tags = {
      Name = "${var.vpc_name}-nat"
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.three_tire.id

    tags = {
      Name = "${var.vpc_name}-private-rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gtw.id
    }
}

resource "aws_route_table_association" "private_asso" {
    for_each = {
        web-1 = aws_subnet.sub_3.id
        web-2 = aws_subnet.sub_4.id
        app-1 = aws_subnet.sub_5.id
        app-2 = aws_subnet.sub_6.id
        db-1  = aws_subnet.sub_7.id
        db-2  = aws_subnet.sub_8.id
    }

    subnet_id = each.value
    route_table_id = aws_route_table.private_rt.id
  
}