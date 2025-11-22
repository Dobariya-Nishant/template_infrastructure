terraform {
  backend "s3" {
    bucket         = "kea-terraform-dev-state"
    key            = "kea/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "kea-terraform-dev-state-lock"
    encrypt        = true
  }
}