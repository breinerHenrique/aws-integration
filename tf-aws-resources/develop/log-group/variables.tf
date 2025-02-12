variable "log_groups" {
  type    = list(string)
  default = ["ecs_web", "ecs_api", "ecs_worker"]
  description = "Log group used for ECS Tasks"
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