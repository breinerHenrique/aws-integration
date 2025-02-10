variable "cluster_name" {
  type = string
  default = "cluster-ecs-intrack"
}

variable "namespace_name" {
  type = string
  default = "intrack"
}

variable "subnet_ids" {
  type = list(string)
  default = [ "subnet-0fcba3d1ac0b31429", "subnet-0c879643e41e687e2" ]
}

variable "ami_id" {
  description = "AMI ID for ECS instances"
  type        = string
  default = "ami-00a10f2bad86838c2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of ECS instances"
  type        = number
  default = 0
}

variable "min_capacity" {
  description = "Minimum number of ECS instances"
  type        = number
  default = 0
}

variable "max_capacity" {
  description = "Maximum number of ECS instances"
  type        = number
  default = 2
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