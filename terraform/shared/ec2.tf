# ---------------------------------------
# Development bastion EC2 instance
# ---------------------------------------
resource "aws_instance" "splunk-app-bastion" {
  ami                         = "ami-0c1e0061f931b36f8"
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = "splunkapp"
  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name

  tags = {
    Name    = "${var.project}-${var.environment}-bastion"
    Project = var.project
    Env     = var.environment
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
  }

  lifecycle {
  # Prevent replacement caused by public IP release when the instance is stopped.
  ignore_changes = [
    associate_public_ip_address
  ]
}
}
