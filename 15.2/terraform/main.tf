provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.YC_ZONE
}

# Image

data "yandex_compute_image" "ubuntu" {
  family = "lamp"
  # image_id = "fd81u0g6sfk13ivcfcrm" # lamp-v20220711
}

# Группа для Network Load Balancer
resource "yandex_compute_instance_group" "instance-group" {

  name  = "instance-group"
  folder_id           = var.YC_FOLDER_ID
  service_account_id  = yandex_iam_service_account.n15-2.id
  deletion_protection = false

    load_balancer {
      target_group_name = "instance-group"
    }

    instance_template {
      platform_id = "standard-v3"

      resources {
        cores         = 2
        memory        = 1
        core_fraction = 20
      }
    
      boot_disk {
        initialize_params {
          image_id = data.yandex_compute_image.ubuntu.id
          type     = "network-hdd"
          size     = "20"
        }
      }

      network_interface {
        network_id = yandex_vpc_network.network-1.id
        subnet_ids = [yandex_vpc_subnet.public.id]
        nat        = false
        ipv6       = false
      }

      network_settings {
        type = "STANDARD"
      }
   
      metadata = {
      user-data = <<EOF
#!/bin/bash
echo "<html><p>Netwrok Load Balancer</p><p>"`cat /etc/hostname`"</p><img src="https://storage.yandexcloud.net/${yandex_storage_object.logo.bucket}/${yandex_storage_object.logo.key}" alt="logo"></html>" > /var/www/html/index.html
EOF
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
      
      # metadata = {
      #   user-data = "${file(var.user_data)}"
      # }
    }

    scale_policy {
      fixed_scale {
        size = 3
      }
    }

    allocation_policy {
      zones = [var.YC_ZONE]
    }

    deploy_policy {
      max_unavailable = 3
      max_expansion   = 0
      max_deleting    = 3
      max_creating    = 3
    }
}

# Группа для Application Load Balancer

resource "yandex_compute_instance_group" "app-lb" {
  name                = "app-lb"
  folder_id           = var.YC_FOLDER_ID
  service_account_id  = yandex_iam_service_account.n15-2.id
  deletion_protection = false

  application_load_balancer {
    target_group_name = "app-lb"
  }

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu.id
        type     = "network-hdd"
        size     = "20"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network-1.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = false
      ipv6       = false
    }

    network_settings {
      type = "STANDARD"
    }

    metadata = {
      user-data = <<EOF
#!/bin/bash
echo "<html><p>Application Load Balancer</p><p>"`cat /etc/hostname`"</p><img src="https://storage.yandexcloud.net/${yandex_storage_object.logo.bucket}/${yandex_storage_object.logo.key}" alt="logo"></html>" > /var/www/html/index.html
EOF
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
    
    # metadata = {
    #     user-data = "${file(var.user_data)}"
    #   }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.YC_ZONE]
  }

  deploy_policy {
    max_unavailable = 3
    max_expansion   = 0
    max_deleting    = 3
    max_creating    = 3
  }
}