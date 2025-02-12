terraform {
  backend "s3" {
    bucket = "backend-terraform-state-breiner"
    key    = "project/develop/sg-ecs-task-web.tfstate"
    region = "us-east-1"
  }
}
