# 1. Ресурсы VPC
resource "yandex_vpc_network" "main" {
  name = "task-network"
}

# Публичная подсеть
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Приватная подсеть
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private.id
}

# 2. NAT-инстанс в публичной подсети
resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  platform_id = "standard-v3"
  zone        = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
      type     = "network-ssd"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    ipv4      = true
    # Статический IP, чтобы его было удобно прописать в маршрутах
    ip_address = "192.168.10.254" 
  }

  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: yc-user
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${file("~/.ssh/id_rsa.pub")}
runcmd:
  - [sysctl, -w, net.ipv4.ip_forward=1]
  - [iptables, -t, nat, -A, POSTROUTING, -o, eth0, -j, MASQUERADE]
EOF
  }
}

# 3. Таблица маршрутизации для приватной подсети
resource "yandex_vpc_route_table" "private" {
  name       = "private-rt"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254" // IP NAT-инстанса
  }
}

# 4. Публичная виртуальная машина
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  platform_id = "standard-v3"
  zone        = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8v0s6adqu3ui3rsuap"
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true // Выделяем публичный IP
  }

  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: yc-user
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${file("~/.ssh/id_rsa.pub")}
EOF
  }
}

# 5. Приватная виртуальная машина
resource "yandex_compute_instance" "private_vm" {
  name        = "private_vm_name"
  platform_id = "standard-v3"
  zone        = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8v0s6adqu3ui3rsuap"
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false // Публичного IP нет
  }

  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: yc-user
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${file("~/.ssh/id_rsa.pub")}
EOF
  }
}

# 6. Вывод данных для подключения
output "public_vm_ip" {
  description = "Публичный IP виртуальной машины в публичной подсети"
  value       = yandex_compute_instance.public_vm.network_interface.0.nat_ip_address
}

output "private_vm_internal_ip" {
  description = "Внутренний IP виртуальной машины в приватной подсети"
  value       = yandex_compute_instance.private_vm.network_interface.0.ip_address
}

output "nat_instance_internal_ip" {
  description = "Внутренний IP NAT-инстанса"
  value       = yandex_compute_instance.nat.network_interface.0.ip_address
}
