terraform {
  backend "s3" {
    bucket         = "pa-devops-terraform-state"
    key            = "test-lambda/terraform.tfstate"
    dynamodb_table = "pa-devops-terraform-state"
    region         = "us-east-1"
    profile        = "default"
  }
}
