resource "aws_autoscaling_attachment" "rs_asg_tg_attachment" {
  autoscaling_group_name = var.asg_name
  alb_target_group_arn   = var.alb_target_group_arn
}