# ---------------------------------------
# IAM roles, policies, and instance profiles
# ---------------------------------------

resource "aws_iam_role" "bastion_role" {
  name = "${var.project}-${var.environment}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name    = "${var.project}-${var.environment}-bastion-role"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.project}-${var.environment}-bastion-profile"
  role = aws_iam_role.bastion_role.name
}
