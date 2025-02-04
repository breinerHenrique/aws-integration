locals {
  repository_name = ["app1-repo", "app2-repo", "app3-repo"]
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}