resource "google_compute_url_map" "url_map" {
  name            = "${var.load_balancer_name}-url-map"
  default_service = google_compute_backend_service.load_balancer.id
}

resource "google_compute_target_http_proxy" "target_proxy" {
  name       = "${var.load_balancer_name}-target-proxy"
  url_map    = google_compute_url_map.url_map.id
  proxy_bind = false
  #ssl_certificates = []
}

resource "google_compute_global_forwarding_rule" "rule" {
  name                  = "${var.load_balancer_name}-forwarding-rule"
  ip_address            = google_compute_global_address.ip_address.address
  ip_protocol           = "TCP"
  port_range            = var.port_range
  target                = google_compute_target_http_proxy.target_proxy.self_link
  load_balancing_scheme = "EXTERNAL"
  depends_on            = [google_compute_target_http_proxy.target_proxy, google_compute_global_address.ip_address]
}
