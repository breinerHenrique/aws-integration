variable "sg_ecs_web" {
  type    = string
  default = "ecs-web-sg"
  description = "Security Group used for ECS Web Task"
}

variable "description_sg_ecs_web" {
  type    = string
  default = "Allow traffic from e to ECS Web Task"
}

variable "vpc_id" {
  type    = string
  default = "vpc-08e61a40f31e32d38"
  description = "VPC ID used by ECS Web Taks"
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