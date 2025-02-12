output "created_log_groups" {
  description = "List of all Log Groups created"
  value       = [for lg in aws_cloudwatch_log_group.log_groups : lg.name]
}