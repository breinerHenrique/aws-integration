variable "task_execution_role_name" {
  type = string
  default = "ecsTaskExecutionRole"
  description = "Role used for all ECS Tasks"
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