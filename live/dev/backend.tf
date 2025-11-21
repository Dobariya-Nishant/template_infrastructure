terraform {
  backend "s3" {
    bucket         = "kea-terraform-state-dev"
    key            = "kea/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-backend-lock"
    encrypt        = true
  }
}