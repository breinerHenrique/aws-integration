terraform {
  backend "s3" {
    bucket = "backend-terraform-state-breiner"
    key    = "project/develop/bucket-s3.tfstate"
    region = "us-east-1"
  }
}
