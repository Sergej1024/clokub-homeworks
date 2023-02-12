resource "yandex_vpc_network" "network" {
  name = "network-netology-15"
}

resource "yandex_vpc_subnet" "publicA" {
  name = "public-A"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.network.id
}

resource "yandex_vpc_subnet" "publicB" {
  name = "public-B"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone = "ru-central1-b"
  network_id = yandex_vpc_network.network.id
}

resource "yandex_vpc_subnet" "publicC" {
  name = "public-C"
  v4_cidr_blocks = ["192.168.30.0/24"]
  zone = "ru-central1-c"
  network_id = yandex_vpc_network.network.id
}

resource "yandex_vpc_subnet" "privateA" {
  name = "private-A"
  v4_cidr_blocks = ["192.168.110.0/24"]
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.network.id
}

resource "yandex_vpc_subnet" "privateB" {
  name = "private-B"
  v4_cidr_blocks = ["192.168.120.0/24"]
  zone = "ru-central1-b"
  network_id = yandex_vpc_network.network.id
}

resource "yandex_vpc_subnet" "privateC" {
  name = "private-C"
  v4_cidr_blocks = ["192.168.130.0/24"]
  zone = "ru-central1-c"
  network_id = yandex_vpc_network.network.id
}
