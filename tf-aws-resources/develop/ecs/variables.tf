variable "cluster_name" {
  type = string
  default = "cluster-ecs-intrack"
}

variable "subnet_ids" {
  type = list(string)
  default = [ "intrack_backend", "intrack_mqtt", "intrack_mobile" ]
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