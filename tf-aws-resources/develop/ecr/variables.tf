variable "repository_name" {
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