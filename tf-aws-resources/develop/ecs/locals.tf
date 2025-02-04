locals {
  region = "us-east-1"
  aws-account = "236730285067"
  name   = "ecs-cluster-dev"

  log_group_name = "/aws/ecs/ecs-cluster-dev"

  vpc_cidr = "172.31.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 1)

  container_name = "ecsdemo-frontend"
  container_port = 80

  tags = {
    Name       = local.name
    Example    = local.name
    Environment = "Development"
    Project     = "EcsEc2"
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecs"
  }
}