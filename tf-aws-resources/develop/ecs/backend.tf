terraform {
  backend "s3" {
    bucket = "backend-terraform-state-breiner"
    key    = "project/develop/ecs-cluster.tfstate"
    region = "us-east-1"
  }
}
