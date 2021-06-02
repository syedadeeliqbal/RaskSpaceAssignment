# resource "aws_lb_listener" "alb_web_listener" {
#   load_balancer_arn = var.alb_arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = var.alb_tg_arn
#   }
# }