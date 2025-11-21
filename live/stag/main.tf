module "vpc" {
  source = "../../modules/vpc"

  project_name             = var.project_name
  environment              = var.environment
  cidr_block               = "11.0.0.0/16"
  public_subnets           = ["11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24"]
  frontend_private_subnets = ["11.0.11.0/24", "11.0.11.0/24", "11.0.12.0/24"]
  backend_private_subnets  = ["11.0.20.0/24", "11.0.21.0/24", "11.0.22.0/24"]
  database_private_subnets = ["11.0.30.0/24", "11.0.31.0/24", "11.0.32.0/24"]
  availability_zones       = ["us-east-1a", "us-east-1b", "us-east-1c"]
  enable_nat_gateway       = true
}
