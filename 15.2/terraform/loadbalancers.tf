
################################################################################
# Network Load Balancer

resource "yandex_lb_network_load_balancer" "instance-group" {
  name = "instance-group"

  listener {
    name = "instance-group"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.instance-group.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

################################################################################
# Application Load Balancer

resource "yandex_alb_http_router" "app-lb" {
  name = "app-lb"
  labels = {
    tf-label    = "app-lb"
    empty-label = ""
  }
}

resource "yandex_alb_backend_group" "app-lb" {
  name = "app-lb"

  http_backend {
    name             = "test-http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_compute_instance_group.app-lb.application_load_balancer[0].target_group_id]
    # tls {
    #   sni = "backend-domain.internal"
    # }
    load_balancing_config {
      panic_threshold = 5
    }
    healthcheck {
      timeout  = "1s"
      interval = "1s"
      http_healthcheck {
        path = "/"
      }
    }
    http2 = "false"
  }
}

resource "yandex_alb_virtual_host" "app-lb" {
  name           = "app-lb"
  http_router_id = yandex_alb_http_router.app-lb.id
  route {
    name = "http"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.app-lb.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "app-lb" {
  name = "app-lb"

  network_id = yandex_vpc_network.network-1.id

  allocation_policy {
    location {
      zone_id   = var.YC_ZONE #"ru-central1-a"
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "app-lb"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.app-lb.id
      }
    }
  }
}