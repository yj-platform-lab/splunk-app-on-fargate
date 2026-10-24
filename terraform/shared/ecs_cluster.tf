# ---------------------------------------
# ECS cluster for Fargate
# ---------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.environment}-cluster"

  tags = {
    Project = var.project
    Env     = var.environment
  }
}
