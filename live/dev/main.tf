module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  cidr_block         = "12.0.0.0/16"
  public_subnets     = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
  rds_allowed_ips    = ["0.0.0.0/0"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  enable_nat_gateway = false
}

module "alb" {
  source          = "../../modules/alb"
  name            = "main"
  project_name    = var.project_name
  environment     = var.environment
  subnet_ids      = module.vpc.public_subnets
  security_groups = [module.vpc.alb_sg]
  vpc_id          = module.vpc.id

  target_groups = {
    frontend = {
      name              = "frontend"
      port              = 80
      protocol          = "HTTP"
      target_type       = "ip"
      health_check_path = "/"
    }
    backend = {
      name              = "backend"
      port              = 80
      protocol          = "HTTP"
      target_type       = "ip"
      health_check_path = "/health"
    }
  }

  listener = {
    name             = "main"
    target_group_key = "frontend"
    rules = {
      api_rule = {
        description      = "API path routing"
        target_group_key = "backend"
        hosts            = ["dev.api.keatech.net"]
      }
    }
  }
}

module "cluster" {
  source = "../../modules/ecs/cluster"

  project_name        = var.project_name
  environment         = var.environment
  fargate_base        = 0
  fargate_weight      = 1
  fargate_spot_weight = 4
  fargate_spot_base   = 0
}

module "backend_ecr" {
  source = "../../modules/ecr"

  name             = "backend"
  prev_image_count = 10
  project_name     = var.project_name
  environment      = var.environment
}

