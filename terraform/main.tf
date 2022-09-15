# Create VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "lamp-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  public_subnets  = ["10.0.160.0/19", "10.0.192.0/19", "10.0.224.0/19"]
  tags = {
    Module = "terraform-aws-modules/vpc/aws"
  }
}

# Create ECS Cluster

# Create RDS

# Create ECS
