terraform {
  backend "s3" {
    bucket = "backend-terraform-state-breiner"
    key    = "project/develop/iam-role-ecs-task.tfstate"
    region = "us-east-1"
  }
}
