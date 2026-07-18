resource "yandex_compute_instance" "web" {
  count = 2
 
  depends_on = [ yandex_compute_instance.db ]

  name        = "web-${count.index + 1}"
  platform_id = var.default_vm_instance.platform_id

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.default_vm_instance.disk_size
      type     = var.default_vm_instance.disk_type
    }
  }
  resources {
    cores         = var.default_vm_instance.cores
    memory        = var.default_vm_instance.memory
    core_fraction = var.default_vm_instance.core_fraction
  }
  scheduling_policy {
    preemptible = var.default_vm_instance.preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [ yandex_vpc_security_group.example.id]
    nat                = var.default_vm_instance.nat
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub/")}"
  }
}
