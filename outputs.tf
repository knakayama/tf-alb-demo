output "web_public_ips" {
  value = "${join(", ", aws_spot_instance_request.web.*.public_ip)}"
}

output "alb_dns_name" {
  value = "${aws_alb.alb.dns_name}"
}
