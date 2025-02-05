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

module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "service1"
  cluster_arn = module.ecs_cluster.arn

  # cpu    = 100
  # memory = 128

  launch_type = "EC2"
  propagate_tags = "SERVICE"
  enable_autoscaling = false

  # Container definition(s)
  container_definitions = {

    # fluent-bit = {
    #   cpu       = 50
    #   memory    = 64
    #   essential = true
    #   image     = "906394416424.dkr.ecr.us-west-2.amazonaws.com/aws-for-fluent-bit:stable"
    #   enable_cloudwatch_logging = false
    #   # firelens_configuration = {
    #   #   type = "fluentbit"
    #   # }
    #   memory_reservation = 50
    # }

    ecs-sample = {
      cpu       = 50
      memory    = 64
      essential = true
      image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
      port_mappings = [
        {
          name          = "ecs-sample"
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false

      # dependencies = [{
      #   containerName = "fluent-bit"
      #   condition     = "START"
      # }]

      enable_cloudwatch_logging = false
      # log_configuration = {
      #   logDriver = "awsfirelens"
      #   options = {
      #     Name                    = "firehose"
      #     region                  = "eu-west-1"
      #     delivery_stream         = "my-stream"
      #     log-driver-buffer-limit = "2097152"
      #   }
      # }
      memory_reservation = 50
    }
  }

  # service_connect_configuration = {
  #   namespace = "example"
  #   service = {
  #     client_alias = {
  #       port     = 80
  #       dns_name = "ecs-sample"
  #     }
  #     port_name      = "ecs-sample"
  #     discovery_name = "ecs-sample"
  #   }
  # }

  # load_balancer = {
  #   service = {
  #     target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:1234567890:targetgroup/bluegreentarget1/209a844cd01825a4"
  #     container_name   = "ecs-sample"
  #     container_port   = 80
  #   }
  # }

  subnet_ids = [ "subnet-0fcba3d1ac0b31429", "subnet-0c879643e41e687e2" ]
  # security_group_rules = {
  #   alb_ingress_3000 = {
  #     type                     = "ingress"
  #     from_port                = 80
  #     to_port                  = 80
  #     protocol                 = "tcp"
  #     description              = "Service port"
  #     source_security_group_id = "sg-12345678"
  #   }
  #   egress_all = {
  #     type        = "egress"
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # }

  tags = var.tags
}