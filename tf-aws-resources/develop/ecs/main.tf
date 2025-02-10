module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"
  depends_on = [ aws_service_discovery_http_namespace.this ]

  cluster_name = var.cluster_name

  cluster_service_connect_defaults = {
    namespace = aws_service_discovery_http_namespace.this.arn
  }

 # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/${var.cluster_name}"
      }
    }
  }

  tags = var.tags
}

resource "aws_service_discovery_http_namespace" "this" {
  name        = var.namespace_name
  description = "CloudMap namespace for ${var.cluster_name}"
  tags        = var.tags
}

# resource "aws_iam_role" "ecs_instance_role" {
#   name = "${var.cluster_name}_instace_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = var.tags
# }


# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role" {
#   depends_on = [ aws_iam_role.ecs_instance_role ]
#   role       = aws_iam_role.ecs_instance_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }

# resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
#   depends_on = [ aws_iam_role.ecs_instance_role ]
#   role       = aws_iam_role.ecs_instance_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM" {
#   depends_on = [ aws_iam_role.ecs_instance_role ]
#   role       = aws_iam_role.ecs_instance_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
# }

# resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
#   depends_on = [ aws_iam_role.ecs_instance_role ]
#   role       = aws_iam_role.ecs_instance_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }

# resource "aws_iam_instance_profile" "ecs_instance_profile" {
#   depends_on = [ aws_iam_role.ecs_instance_role ]
#   name = "${var.cluster_name}_instace_profile"
#   role = aws_iam_role.ecs_instance_role.name
# }

# resource "aws_launch_template" "ecs" {
#   depends_on = [ aws_iam_instance_profile.ecs_instance_profile ]
#   name_prefix   = var.cluster_name
#   image_id      = var.ami_id
#   instance_type = var.instance_type

#   iam_instance_profile {
#     arn =  aws_iam_instance_profile.ecs_instance_profile.arn
#   }

#   ebs_optimized = true
#   block_device_mappings {
#     device_name = "/dev/sdf"

#     ebs {
#       volume_size = 20
#     }
#   }

#   monitoring {
#     enabled = true
#   }

#   user_data = base64encode(<<-EOF
#               #!/bin/bash
#               echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
#               echo "ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true" >> /etc/ecs/ecs.config
#               echo 'ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]' | sudo tee -a /etc/ecs/ecs.config  
#               EOF
#   )

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "${var.cluster_name}-instance"
#     }
#   }
# }

# resource "aws_autoscaling_group" "ecs" {
#   desired_capacity     = var.desired_capacity
#   min_size            = var.min_capacity
#   max_size            = var.max_capacity
#   vpc_zone_identifier = var.subnet_ids

#   launch_template {
#     id      = aws_launch_template.ecs.id
#     version = "$Latest"
#   }

#   tag {
#     key                 = "AmazonECSCluster"
#     value               = var.cluster_name
#     propagate_at_launch = true
#   }
# }
