# ---------------------------------------
# Security groups and ingress/egress rules
# ---------------------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-${var.environment}-ec2-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-ec2-sg"
    Project = var.project
    Env     = var.environment
  }
}


resource "aws_vpc_security_group_ingress_rule" "ec2_ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.ssh_source_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# SG for Fargate
resource "aws_security_group" "fargate_sg" {
  name        = "${var.project}-${var.environment}-fargate-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-fargate-sg"
    Project = var.project
    Env     = var.environment
  }
}

# EC2 -> Fargate：Splunk Web
resource "aws_vpc_security_group_ingress_rule" "fargate_web" {
  security_group_id            = aws_security_group.fargate_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 8000
  to_port                      = 8000
}

resource "aws_vpc_security_group_egress_rule" "ec2_out" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.ssh_source_cidr
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "fargate_out" {
  security_group_id = aws_security_group.fargate_sg.id
  cidr_ipv4         = var.ssh_source_cidr
  ip_protocol       = "-1"
}

# SG for EFS
resource "aws_security_group" "efs_sg" {
  name        = "${var.project}-${var.environment}-efs-sg"
  description = "Allow NFS from EC2 and Fargate"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-efs-sg"
    Project = var.project
    Env     = var.environment
  }
}

# EC2 -> EFS
resource "aws_vpc_security_group_ingress_rule" "efs_from_ec2" {
  security_group_id            = aws_security_group.efs_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 2049
  to_port                      = 2049
}

# Fargate -> EFS
resource "aws_vpc_security_group_ingress_rule" "efs_from_fargate" {
  security_group_id            = aws_security_group.efs_sg.id
  referenced_security_group_id = aws_security_group.fargate_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 2049
  to_port                      = 2049
}

