resource "aws_route53_record" "this" {
  zone_id = var.route53_zone_id
  name    = "api"
  type    = "CNAME"
  ttl     = "30"

  records = [aws_lb.this.dns_name]
}
