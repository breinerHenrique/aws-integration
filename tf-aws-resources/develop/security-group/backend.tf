terraform {
  backend "s3" {
    bucket = "backend-terraform-state-breiner"
    key    = "project/develop/sg-ecs-tasks.tfstate"
    region = "us-east-1"
  }
}
