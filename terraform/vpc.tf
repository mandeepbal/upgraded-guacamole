# Create VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.4"

  name            = "lamp-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  public_subnets  = ["10.0.160.0/19", "10.0.192.0/19", "10.0.224.0/19"]
  tags = {
    Module = "terraform-aws-modules/vpc/aws"
  }

  # NAT GW needed for ECR https://stackoverflow.com/questions/61265108/aws-ecs-fargate-resourceinitializationerror-unable-to-pull-secrets-or-registry
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

# Create SG for the ALB
resource "aws_security_group" "lamp_alb" {
  name   = "lamp-alb"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Create SG for the ECS web task
# Allow sg.lamp-app access to forward web traffic to any port
resource "aws_security_group" "lamp_web" {
  name   = "lamp-web"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 0
    to_port          = 65535
    security_groups  = [aws_security_group.lamp_alb.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Create SG for the RDS, allow sg.lamp-web 3306 access
resource "aws_security_group" "lamp_rds" {
  name   = "lamp-rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 3306
    to_port          = 3306
    security_groups  = [aws_security_group.lamp_web.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "tcp"
    from_port        = 3306
    to_port          = 3306
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}