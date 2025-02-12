resource "aws_cloudwatch_log_group" "cw_log_groups" {
  for_each          = toset(var.log_groups)
  name              = each.value

  retention_in_days = 7

  tags = var.tags
}