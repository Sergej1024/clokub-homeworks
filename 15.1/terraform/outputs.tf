output "public_ip_public" {
  value = yandex_compute_instance.public_instance[*].network_interface.0.nat_ip_address
  description = "Публичный IP public"
}

output "private_ip_public" {
  value = yandex_compute_instance.public_instance[*].network_interface.0.ip_address
  description = "Приватный IP public"
}

output "public_ip_private" {
  value = yandex_compute_instance.private_instance[*].network_interface.0.nat_ip_address
  description = "Публичный IP private"
}

output "private_ip_private" {
  value = yandex_compute_instance.private_instance[*].network_interface.0.ip_address
  description = "Приватный IP private"
} 