resource "aws_alb" "alb" {
  name                       = "${var.name}"
  security_groups            = ["${aws_security_group.alb.id}"]
  subnets                    = ["${aws_subnet.frontend_subnet.*.id}"]
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket = "${aws_s3_bucket.alb_log.bucket}"
  }
}

resource "aws_alb_target_group" "alb" {
  count    = 2
  name     = "${var.name}-tg${count.index+1}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"

  health_check {
    interval            = 30
    path                = "/index.html"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_target_group_attachment" "alb" {
  count            = 2
  target_group_arn = "${element(aws_alb_target_group.alb.*.arn, count.index)}"
  target_id        = "${element(aws_spot_instance_request.web.*.spot_instance_id, count.index)}"
  port             = 80
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.alb_config["certificate_arn"]}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.0.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "tg2" {
  listener_arn = "${aws_alb_listener.alb.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb.1.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/target/*"]
  }
}
