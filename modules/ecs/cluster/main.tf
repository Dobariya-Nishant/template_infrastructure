# ===========
# ECS Cluster
# ===========

# ECS Cluster with container insights enabled for better observability
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }

  tags = {
    Name = "${var.project_name}-cluster-${var.environment}"
  }
}

# ========================================
# Attach Capacity Providers to ECS Cluster
# ========================================

# Mixed capacity FARGATE
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]


  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = var.fargate_weight
    base              = var.fargate_base
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = var.fargate_spot_weight
    base              = var.fargate_spot_base
  }
}