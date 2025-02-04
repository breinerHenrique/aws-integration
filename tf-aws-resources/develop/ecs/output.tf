# output "repository_name" {
#   value = {
#     for k, v in module.ecr : k => v.repository_name
#   }
#   description = "Name of the repository."
# }

# output "repository_arn" {
#   value = {
#     for k, v in module.ecr : k => v.repository_arn
#   }
#   description = "Full ARN of the repository."
# }