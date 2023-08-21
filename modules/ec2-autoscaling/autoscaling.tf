# Access the image that will be used for creating the launch template
data "aws_ami" "ec2_image" {
  most_recent = true
  
  filter {
    name = "name"
    values = [ "ec2-ami" ]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [ "${var.owners}" ]

}

# Generate the key pair for connection
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

# save the key pair to a file on your localhost
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name

  # provisioner "local-exec" {
  #   command = "chmod 400 ${var.key_name}"
  # }
}

# Create a launch template
resource "aws_launch_template" "my_template" {
    name = "${var.project}-tpl"
    image_id = data.aws_ami.ec2_image.image_id
    instance_type = "t2.micro"
    key_name = aws_key_pair.key_pair.key_name
    vpc_security_group_ids  = [ aws_security_group.ec2-sg.id ]
    # user_data = var.user_data

    tag_specifications {
      resource_type = "instance"
      tags = local.tags
    }
}

# Create autoscaling group
resource "aws_autoscaling_group" "custom_autoscalar" {
  name = "${var.project}-asg"
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  health_check_grace_period = 300
  health_check_type = "EC2"
  vpc_zone_identifier = var.vpc_zone_identifier
  # [for subnet in aws_subnet.private_subnet : subnet.id]
  target_group_arns = [ aws_lb_target_group.test.arn ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id = aws_launch_template.my_template.id
    version = "$Latest"
  }
}


# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project}-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.custom_autoscalar.name
  adjustment_type        = var.adjustment_type == "" ? "ChangeInCapacity" : var.adjustment_type
  scaling_adjustment     = var.scaling_adjustment == "" ? "1" : var.scaling_adjustment #increasing instance by 1 
  cooldown               = var.cooldown == "" ? "150" : var.cooldown
  policy_type            = var.policy_type == "" ? "SimpleScaling" : var.policy_type
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.project}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = var.comparison_operator == "" ? "GreaterThanOrEqualToThreshold" : var.comparison_operator
  evaluation_periods  = var.evaluation_periods == "" ? "2" : var.evaluation_periods
  metric_name         = var.metric_name == ""? "CPUUtilization" : var.metric_name
  namespace           = "AWS/EC2"
  period              = var.period == "" ? "120" : var.period
  statistic           = var.statistic == "" ? "Average" : var.statistic
  threshold           = var.threshold == "" ? "70" : var.threshold # New instance will be created once CPU utilization is higher than 70 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.custom_autoscalar.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project}-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.custom_autoscalar.name
  adjustment_type        = var.adjustment_type == "" ? "ChangeInCapacity" : var.adjustment_type
  scaling_adjustment     = var.scale_down_scaling_adjustment == "" ? "-1" : var.scale_down_scaling_adjustment # decreasing instance by 1 
  cooldown               = var.cooldown == "" ? "150" : var.cooldown
  policy_type            = var.policy_type == "" ? "SimpleScaling" : var.policy_type
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.project}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = var.scale_down_comparison_operator == "" ? "LessThanOrEqualToThreshold" : var.scale_down_comparison_operator
  evaluation_periods  = var.evaluation_periods == "" ? "2" : var.evaluation_periods
  metric_name         = var.metric_name == ""? "CPUUtilization" : var.metric_name
  namespace           = "AWS/EC2"
  period              = var.period == "" ? "120" : var.period
  statistic           = var.statistic == "" ? "Average" : var.statistic
  threshold           = var.scale_down_threshold == "" ? "30" : var.scale_down_threshold # Instance will scale down when CPU utilization is lower than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.custom_autoscalar.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}
