# Create RDS
module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "5.1.0"

  identifier                          = "lamp-db"
  engine                              = "mysql"
  engine_version                      = "8.0.30"
  instance_class                      = "db.t3.micro"
  allocated_storage                   = 20
  db_name                             = "lamp"
  username                            = "web"
  port                                = "3306"
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [aws_security_group.lamp_web.id]
  maintenance_window                  = "Mon:00:00-Mon:03:00"
  backup_window                       = "03:00-06:00"

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"
}