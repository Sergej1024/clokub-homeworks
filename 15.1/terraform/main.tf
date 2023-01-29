provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.YC_ZONE
}

data "yandex_compute_image" "ubuntu" {
  image_id = "fd80mrhj8fl2oe87o4e1"
}

resource "yandex_compute_instance" "public_instance" {

  name      = "n151-public"
  hostname    = "n151-public.local"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    user-data = "${file(var.user_data)}"
  }
}

resource "yandex_compute_instance" "private_instance" {

  name      = "n151-private"
  hostname    = "n151-private.local"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  metadata = {
    user-data = "${file(var.user_data)}"
  }
}

