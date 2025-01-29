terraform {
  backend "s3" {
    bucket = "backend-terraform-state-breiner"
    key    = "project/develop/ecr-repository.tfstate"
    region = "us-east-1"
  }
}
