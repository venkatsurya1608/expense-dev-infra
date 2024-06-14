module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"    # give only backend or var.common_tags.Component
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value] 
  # convert StringList to list and get first element
  subnet_id = local.private_subnet_id
  ami = data.aws_ami.ami_info.id
  

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"    
    }
  )
}

resource "null_resource" "backend" {
    triggers = {
      instance_id = module.backend.id # this will be triggered everytime instance is created
    }

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.backend.private_ip
    }

    provisioner "file" {
        source      = "${var.common_tags.Component}.sh"
        destination = "/tmp/${var.common_tags.Component}.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/${var.common_tags.Component}.sh",
            "sudo sh /tmp/${var.common_tags.Component}.sh ${var.common_tags.Component} ${var.environment}"
        ]
    } 
}


# stop server when only null resource probvisioning is completed  enduke depends on pettamu
resource "aws_ec2_instance_state" "backend" {    #ec2 instance state terraform
  instance_id = module.backend.id
  state       = "stopped"
  depends_on = [null_resource.backend ]
}

resource "aws_ami_from_instance" "backend" {             #aws ami from instance terraform
  name               = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  source_instance_id = module.backend.id
  depends_on = [ aws_ec2_instance_state.backend ]
}

resource "null_resource" "backend_delete" {    # ???
    triggers = {
        instance_id = module.backend.id
    } 

    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.backend.private_ip
    }
    provisioner "local-exec" {
        command = "aws ec2 terminate-instances --instance-ids ${module.backend.id}"   #instance nee terminate chesthunam
    } 
    depends_on = [ aws_ami_from_instance.backend ]
}

resource "aws_lb_target_group" "backend" {
  name     = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value       #aws elb target group with health check terraform

  health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_launch_template" "backend" {
  name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"

  image_id = data.aws_ami.ami_info.id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  update_default_version = true          # sets the latest version to default  vasthundi
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
        }
    )
  }
}

resource "aws_autoscaling_group" "backend" {
  name                      = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  max_size                  = 2  # 5 means max 5 instances run avvali ani 
  min_size                  = 1   # minimum 1 instance run avvali ani
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1   # starting 1 instance create kavali ani
  target_group_arns = [aws_lb_target_group.backend.arn]   # target group ki auto scaling add cheyali
  launch_template {                             # launch template version add chesamu
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_ids.value)

  instance_refresh {
    strategy = "Rolling"       # here rolling means create instance and delete instance refresh avthundali
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
    propagate_at_launch = true
  }


  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Project"
    value               = "${var.project_name}"
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "backend" {
  name                   = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0   # your wish
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 100    # less number will be first vaildated

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.app-${var.environment}.${var.zone_name}"]
    }
  }
}