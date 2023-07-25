
resource "google_compute_managed_ssl_certificate" "certificate" {
  name = "${var.load_balancer_name}-ssl"

  managed {
    domains = ["${var.domain}"]
  }
  type = "MANAGED"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_target_https_proxy" "target_proxy" {
  name             = "${var.load_balancer_name}-target-proxy-https"
  url_map          = google_compute_url_map.url_map.id
  proxy_bind       = false
  quic_override    = "NONE"
  ssl_certificates = [google_compute_managed_ssl_certificate.certificate.id]
}

resource "google_compute_global_forwarding_rule" "rule_https" {
  name                  = "${var.load_balancer_name}-forwarding-rule-https"
  ip_address            = google_compute_global_address.ip_address.address
  ip_protocol           = "TCP"
  port_range            = "443-443"
  target                = google_compute_target_https_proxy.target_proxy.self_link
  load_balancing_scheme = "EXTERNAL"
  depends_on            = [google_compute_target_http_proxy.target_proxy, google_compute_global_address.ip_address]
}
