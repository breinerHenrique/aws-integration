variable "repository_name" {
  type = list(string)
  default = [ "app1-repo", "app2-repo", "app3-repo" ]
}

variable "tags" {
  type = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}