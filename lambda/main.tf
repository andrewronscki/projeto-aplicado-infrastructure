terraform {
  required_version = ">1.1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.46.0"
    }
  }
}

provider "aws" {
  region  = lookup(var.aws_region, local.env)
  profile = var.aws_profile
}

module "lambda" {
  source      = "./modules"
  env         = local.env
  bucket_name = lookup(var.bucket, local.env)["name"]
}
