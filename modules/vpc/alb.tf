# alb.tf

resource "aws_alb" "great_alb" {
  name            = "great-alb"
  subnets         = [aws_subnet.great_pub_sub_1.id, aws_subnet.great_pub_sub_2.id] 
  security_groups  = [aws_security_group.lb.id]          
} 
resource "aws_alb_target_group" "great_tg" {
  name        = "great-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.great_vpc.id
  target_type = "ip"

 health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.great_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.great_tg.arn
    type             = "forward"
  }
}