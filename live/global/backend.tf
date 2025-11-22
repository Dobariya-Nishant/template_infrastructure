terraform {
  backend "s3" {
    bucket         = "kea-terraform-global-state"
    key            = "kea/global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-backend-lock"
    encrypt        = true
  }
}