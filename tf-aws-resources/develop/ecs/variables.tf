variable "cluster_name" {
  type = string
  default = "cluster-ecs-intrack"
}

variable "tags" {
  type = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    Repository = ""
    Project = "DevOps"
  }
}