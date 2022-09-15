terraform {
  backend "s3" {
    bucket  = "202209lamp"
    encrypt = true
    key     = "terraform-lamp.tfstate"
    region  = "us-east-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment = "Lamp"
      Terraform   = "true"
      Repo        = "mandeepbal/upgraded-guacamole"
    }
  }
}
