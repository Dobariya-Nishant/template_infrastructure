terraform {
  backend "s3" {
    bucket         = "kea-terraform-stag-state"
    key            = "kea/stag/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-backend-lock"
    encrypt        = true
  }
}