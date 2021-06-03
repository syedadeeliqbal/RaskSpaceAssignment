resource "aws_autoscaling_policy" "rs_asg_target_tracking_policy" {
  name                      = "rs-asg-alb-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = module.rs-asg.instance.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${module.rs-alb.instance.arn_suffix}/${aws_lb_target_group.rs-alb-tg.arn_suffix}"
    }
    target_value = "3"
  }
}
