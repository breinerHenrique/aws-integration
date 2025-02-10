module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name = var.cluster_name

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

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.cluster_name}_instace_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

# resource "aws_iam_role_policy" "ecs_instance_policy" {
#   depends_on = [ aws_iam_role.ecs_instance_role ]
#   name = "${var.cluster_name}_instace_role"
#   role = aws_iam_role.ecs_instance_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:BatchGetImage",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:GetAuthorizationToken",
#           "ecs:RegisterContainerInstance"
#         ]
#         Effect = "Allow"
#         Resource = "*"
#         Sid    = ""
#       }
#     ]
#   })
# }

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role" {
  depends_on = [ aws_iam_role.ecs_instance_role ]
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  depends_on = [ aws_iam_role.ecs_instance_role ]
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM" {
  depends_on = [ aws_iam_role.ecs_instance_role ]
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
  depends_on = [ aws_iam_role.ecs_instance_role ]
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  depends_on = [ aws_iam_role.ecs_instance_role ]
  name = "${var.cluster_name}_instace_profile"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_launch_template" "ecs" {
  depends_on = [ aws_iam_instance_profile.ecs_instance_profile ]
  name_prefix   = var.cluster_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    arn =  aws_iam_instance_profile.ecs_instance_profile.arn
  }

  ebs_optimized = true
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  monitoring {
    enabled = true
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
              echo "ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true" >> /etc/ecs/ecs.config
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs" {
  desired_capacity     = var.desired_capacity
  min_size            = var.min_capacity
  max_size            = var.max_capacity
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSCluster"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}


# module "ecs_service" {
#   source = "terraform-aws-modules/ecs/aws//modules/service"

#   name        = "service1"
#   cluster_arn = module.ecs_cluster.arn

#   # cpu    = 100
#   # memory = 128

#   launch_type = "EC2"
#   propagate_tags = "SERVICE"
#   enable_autoscaling = false

#   # Container definition(s)
#   container_definitions = {

#     # fluent-bit = {
#     #   cpu       = 50
#     #   memory    = 64
#     #   essential = true
#     #   image     = "906394416424.dkr.ecr.us-west-2.amazonaws.com/aws-for-fluent-bit:stable"
#     #   enable_cloudwatch_logging = false
#     #   # firelens_configuration = {
#     #   #   type = "fluentbit"
#     #   # }
#     #   memory_reservation = 50
#     # }

#     ecs-sample = {
#       cpu       = 50
#       memory    = 64
#       essential = true
#       image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
#       port_mappings = [
#         {
#           name          = "ecs-sample"
#           containerPort = 80
#           protocol      = "tcp"
#         }
#       ]

#       # Example image used requires access to write to root filesystem
#       readonly_root_filesystem = false

#       # dependencies = [{
#       #   containerName = "fluent-bit"
#       #   condition     = "START"
#       # }]

#       enable_cloudwatch_logging = false
#       # log_configuration = {
#       #   logDriver = "awsfirelens"
#       #   options = {
#       #     Name                    = "firehose"
#       #     region                  = "eu-west-1"
#       #     delivery_stream         = "my-stream"
#       #     log-driver-buffer-limit = "2097152"
#       #   }
#       # }
#       memory_reservation = 50
#     }
#   }

#   # service_connect_configuration = {
#   #   namespace = "example"
#   #   service = {
#   #     client_alias = {
#   #       port     = 80
#   #       dns_name = "ecs-sample"
#   #     }
#   #     port_name      = "ecs-sample"
#   #     discovery_name = "ecs-sample"
#   #   }
#   # }

#   # load_balancer = {
#   #   service = {
#   #     target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:1234567890:targetgroup/bluegreentarget1/209a844cd01825a4"
#   #     container_name   = "ecs-sample"
#   #     container_port   = 80
#   #   }
#   # }

#   subnet_ids = [ "subnet-0fcba3d1ac0b31429", "subnet-0c879643e41e687e2" ]
#   # security_group_rules = {
#   #   alb_ingress_3000 = {
#   #     type                     = "ingress"
#   #     from_port                = 80
#   #     to_port                  = 80
#   #     protocol                 = "tcp"
#   #     description              = "Service port"
#   #     source_security_group_id = "sg-12345678"
#   #   }
#   #   egress_all = {
#   #     type        = "egress"
#   #     from_port   = 0
#   #     to_port     = 0
#   #     protocol    = "-1"
#   #     cidr_blocks = ["0.0.0.0/0"]
#   #   }
#   # }

#   tags = var.tags
# }