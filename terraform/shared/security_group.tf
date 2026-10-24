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


resource "aws_vpc_security_group_egress_rule" "ec2_out" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.ssh_source_cidr
  ip_protocol       = "-1"
}
