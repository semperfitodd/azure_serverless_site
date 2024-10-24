data "aws_route53_zone" "this" {
  name = var.public_domain

  private_zone = false
}

locals {
  site_domain = "${local.project}.${var.public_domain}"
}

resource "aws_route53_record" "site" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.site_domain
  type    = "CNAME"
  ttl     = 60

  set_identifier = local.project
  records        = [azurerm_cdn_endpoint.this.fqdn]

  weighted_routing_policy {
    weight = 100
  }
}