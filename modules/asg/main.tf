resource "aws_autoscaling_group" "rs-asg" {
  desired_capacity   = 2
  max_size           = 6
  min_size           = 2 

  target_group_arns = [var.tg_arn]

  health_check_grace_period = 300
  # health_check_type         = "ELB"

    vpc_zone_identifier  = [
    var.subnet1_id,
    var.subnet2_id
  ]

  launch_template {
    id      = var.launch_template_id
  }
}