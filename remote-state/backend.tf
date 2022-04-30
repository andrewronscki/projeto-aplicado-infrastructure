terraform {
  required_version = "1.1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
  backend "s3" {
    bucket         = "pa-devops-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pa-devops-terraform-state"
    profile        = "default"
  }
}
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
