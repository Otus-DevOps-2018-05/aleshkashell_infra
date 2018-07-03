# создется группа инстнасов для балансировки
resource "google_compute_instance_group" "reddit_app_group" {
  name        = "reddit-app-group"
  description = "apps group"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "${var.zone}"
}

# Правило firewall для балансировщика
resource "google_compute_firewall" "firewall_balancer" {
  name = "allow-from-load-balancer"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
  }

  # Каким адресам разрешаем доступ
  # Надо ограничить внутренними адресами гугл
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с тегом  ... 
  target_tags = ["reddit-app"]
}

# Backend с указанием группы хостов и health checks
resource "google_compute_backend_service" "reddit_app_backend" {
  name                            = "reddit-backend"
  port_name                       = "http"
  protocol                        = "HTTP"
  timeout_sec                     = 10
  connection_draining_timeout_sec = 20

  health_checks = ["${google_compute_http_health_check.reddit_health_check.self_link}"]

  backend {
    group = "${google_compute_instance_group.reddit_app_group.self_link}"
  }
}

# Health check по порту
resource "google_compute_http_health_check" "reddit_health_check" {
  name         = "reddit-health-check"
  request_path = "/"

  timeout_sec        = 1
  check_interval_sec = 1
  port               = "9292"
}

# Вirect traffic to different instances based on the incoming URL
resource "google_compute_url_map" "reddit_url_map" {
  name = "reddit-url-map"

  default_service = "${google_compute_backend_service.reddit_app_backend.self_link}"
}

# Proxy для принятия запросов их переправки
resource "google_compute_target_http_proxy" "reddit_app_http_proxy" {
  name        = "reddit-app-http-proxy"
  description = "a description"
  url_map     = "${google_compute_url_map.reddit_url_map.self_link}"
}

# Связываем ip:port с прокси
resource "google_compute_global_forwarding_rule" "reddit_app_forwarding_rule" {
  name       = "reddit-app-forwarding-rule"
  target     = "${google_compute_target_http_proxy.reddit_app_http_proxy.self_link}"
  port_range = "80"
}
