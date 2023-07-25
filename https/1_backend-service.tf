resource "google_compute_global_address" "ip_address" {
  address_type  = "EXTERNAL"
  ip_version    = "IPV4"
  name          = var.ip_name #"${var.load_balancer_name}-address"
  prefix_length = "0"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/ping"
    port         = var.exposed_port
  }
}

resource "google_compute_backend_service" "load_balancer" {
  name                  = var.load_balancer_name
  port_name             = "http"
  session_affinity      = "NONE"
  protocol              = "HTTP"
  timeout_sec           = 300
  health_checks         = [google_compute_health_check.autohealing.id]
  load_balancing_scheme = "EXTERNAL"

  backend {
    balancing_mode  = "RATE"
    capacity_scaler = 1
    group           = var.instance_group
    # max_utilization              = 0.8
    max_rate_per_instance = var.max_connections_per_instance
  }
  log_config {
    enable = true
  }
}

output "ip" {
  value = google_compute_global_address.ip_address.address
}
