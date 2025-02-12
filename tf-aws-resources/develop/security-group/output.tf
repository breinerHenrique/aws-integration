output "sg_ecs_web" {
  description = "ID from SG used to ECS Web Task"
  value       = resource.aws_security_group.sg_ecs_web.id
}