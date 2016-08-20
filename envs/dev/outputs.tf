output "web_public_ips" {
  value = "${module.dev.web_public_ips}"
}

output "alb_dns_name" {
  value = "${module.dev.alb_dns_name}"
}
