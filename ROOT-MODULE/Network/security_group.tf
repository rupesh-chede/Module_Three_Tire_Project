###############################################
# Bastion Host SG
###############################################
resource "aws_security_group" "bastion_host" {
  name        = "bastion-host-sg"
  description = "Allow SSH from allowed CIDRs"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-sg"
  }
}

###############################################
# Frontend ALB Security Group
###############################################
resource "aws_security_group" "alb_frontend" {
  name        = "alb-frontend-sg"
  description = "Allow HTTP/HTTPS from public"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-frontend-sg"
  }
}

###############################################
# Frontend Server SG → Allow ALL from Frontend ALB
###############################################
resource "aws_security_group" "frontend_server" {
  name        = "frontend-server-sg"
  description = "Allow all from ALB + SSH from Bastion"
  vpc_id      = var.vpc_id

  # ALLOW ALL TRAFFIC FROM FRONTEND ALB
  ingress {
    description     = "Allow all traffic from Frontend ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_frontend.id]
  }

  # Allow SSH from Bastion
  ingress {
    description     = "Allow SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-server-sg"
  }
}

###############################################
# Backend ALB SG → Allow traffic only from Frontend Servers
###############################################
resource "aws_security_group" "alb_backend" {
  name        = "alb-backend-sg"
  description = "Allow HTTP from frontend servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from Frontend Server SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_server.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-backend-sg"
  }
}

###############################################
# Backend Server SG → Allow ALL from Frontend Server + Backend ALB
###############################################
resource "aws_security_group" "backend_server" {
  name        = "backend-server-sg"
  description = "Allow all from Frontend + Backend ALB + SSH from Bastion"
  vpc_id      = var.vpc_id

  # Allow all from Frontend server SG
  ingress {
    description     = "Allow all from Frontend Server SG"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.frontend_server.id]
  }

  # Allow all from Backend ALB
  ingress {
    description     = "Allow all from Backend ALB SG"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_backend.id]
  }

  # Allow SSH from Bastion
  ingress {
    description     = "Allow SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-server-sg"
  }
}

###############################################
# Database SG → Allow only Backend Server
###############################################
resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Allow DB traffic only from backend servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow MySQL from Backend Server SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_server.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}
