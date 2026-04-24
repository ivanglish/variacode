terraform {
  backend "s3" {
    bucket = "variacode-bucket"
    key    = "ecs-project/terraform.tfstate"
    region = "sa-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.7"
}

provider "aws" {
  region = "sa-east-1"
}