resource "yandex_vpc_network" "network-1" {
  name = "net"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network-1.id
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"]
  network_id     = yandex_vpc_network.network-1.id
  route_table_id = yandex_vpc_route_table.private_to_public.id
}

resource "yandex_vpc_route_table" "private_to_public" {
  name       = "private_to_public"
  network_id = yandex_vpc_network.network-1.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.public_instance.network_interface.0.ip_address
  }
}
