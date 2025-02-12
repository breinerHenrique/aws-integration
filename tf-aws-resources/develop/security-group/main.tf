resource "aws_security_group" "sg_ecs_web" {
  name        = var.sg_ecs_web
  description = var.description_sg_ecs_web
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "ecs_web_in_3000tcp" {
  security_group_id = aws_security_group.sg_ecs_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_egress_rule" "ecs_web_out_all" {
  security_group_id = aws_security_group.sg_ecs_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}