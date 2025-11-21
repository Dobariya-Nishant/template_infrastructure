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
  source          = "../../../modules/alb"
  name            = "main"
  project_name    = var.project_name
  environment     = var.environment
  subnet_ids      = module.vpc.public_subnets
  security_groups = module.vpc.alb_sg
  vpc_id          = local.vpc_id

  target_groups = {
    api = {
      name              = "api"
      port              = 80
      protocol          = "HTTP"
      target_type       = "ip"
      health_check_path = "/health"
    }
  }

  listener = {
    name             = "main"
    target_group_key = "web"
    rules = {
      api_rule = {
        description      = "API path routing"
        target_group_key = "api"
        hosts            = ["dev.api.kea.net"]
      }
    }
  }
}

module "cluster" {
  source = "../../modules/ecs/cluster"

  project_name = var.project_name
  environment  = var.environment
}

module "backend_ecr" {
  source = "../../modules/ecr"

  name             = "backend"
  prev_image_count = 10
  project_name     = var.project_name
  environment      = var.environment
}
