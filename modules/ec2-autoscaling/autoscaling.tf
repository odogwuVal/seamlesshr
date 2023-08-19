# Access the image that will be used for creating the launch template
data "aws_ami" "ubuntu_image" {
  most_recent = true
  
  filter {
    name = "name"
    values = [ "rest-api" ]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [ "${var.owners}" ]

}

# Access the key pair that will be attached to the instances
data "aws_key_pair" "example" {
  key_name           = "theorem"
  include_public_key = true
}

# Create a launch template
resource "aws_launch_template" "my_template" {
    name = "${var.project}-tpl"
    image_id = data.aws_ami.ubuntu_image.image_id
    instance_type = "t2.micro"
    key_name = data.aws_key_pair.example.key_name
    vpc_security_group_ids  = [ aws_security_group.instance_sg.id ]

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
  vpc_zone_identifier = [for subnet in aws_subnet.private_subnet : subnet.id]
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
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "150"
  policy_type            = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.project}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70" # New instance will be created once CPU utilization is higher than 70 %
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
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "150"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.project}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30" # Instance will scale down when CPU utilization is lower than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.custom_autoscalar.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}
