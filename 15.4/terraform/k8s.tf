resource "yandex_kubernetes_cluster" "n15" {
  name        = "n15"
  description = "Netology cource, 15.4"

  network_id = yandex_vpc_network.network.id

  kms_provider {
    key_id = yandex_kms_symmetric_key.n15.id
  }

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.publicA.zone
        subnet_id = yandex_vpc_subnet.publicA.id
      }

      location {
        zone      = yandex_vpc_subnet.publicB.zone
        subnet_id = yandex_vpc_subnet.publicB.id
      }

      location {
        zone      = yandex_vpc_subnet.publicC.zone
        subnet_id = yandex_vpc_subnet.publicC.id
      }
    }

    version   = "1.21"
    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }

      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.n15.id
  node_service_account_id = yandex_iam_service_account.n15.id

  release_channel = "STABLE"

  depends_on = [
    yandex_resourcemanager_folder_iam_member.editor
  ]
}

resource "yandex_kubernetes_node_group" "n15" {
  cluster_id  = yandex_kubernetes_cluster.n15.id
  name        = "name"
  description = "description"
  version     = "1.21"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = [
        yandex_vpc_subnet.publicA.id
        # > quantity of provided subnets doesn't match that of provided locations
        # yandex_vpc_subnet.publicA.id,
        # yandex_vpc_subnet.publicB.id,
        # yandex_vpc_subnet.publicC.id
      ]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      initial = 3
      min = 3
      max = 6
    }
  }

  allocation_policy {
    location {
      zone      = yandex_vpc_subnet.publicA.zone
      # subnet_id = yandex_vpc_subnet.publicA.id
    }

    # > rpc error: code = InvalidArgument desc = Validation error: allocation_policy.locations: auto scale node groups can have only one location
    # > Доступно только одно расположение при автоматическом масштабировании
    
    # location {
    #   zone      = yandex_vpc_subnet.publicB.zone
    #   # subnet_id = yandex_vpc_subnet.publicB.id
    # }

    # location {
    #   zone      = yandex_vpc_subnet.publicC.zone
    #   # subnet_id = yandex_vpc_subnet.publicC.id
    # }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}