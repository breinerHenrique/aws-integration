variable "cluster_name" {
  type = string
  default = "cluster-ecs-intrack"
}

variable "subnet_ids" {
  type = list(string)
  default = [ "subnet-0fcba3d1ac0b31429", "subnet-0c879643e41e687e2" ]
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