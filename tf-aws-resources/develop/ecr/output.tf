output "repository_arn" {
  value = {
    for k, v in module.ecr : k => v.repository_arn
  }
  description = "Full ARN of the repository."
}