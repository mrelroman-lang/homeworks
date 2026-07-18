resource "yandex_compute_instance" "db" {
  for_each = {
    0 = "main"
    1 = "replica"
  } 
  name        = var.each_vm[each.key].vm_name
  platform_id = var.default_vm_instance.platform_id

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.each_vm[each.key].disk_volume
      type     = var.default_vm_instance.disk_type
    }
  }
  resources {
    cores         = var.each_vm[each.key].cpu
    memory        = var.each_vm[each.key].ram
    core_fraction = var.each_vm[each.key].core_fraction
  }
  scheduling_policy {
    preemptible = var.default_vm_instance.preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [ yandex_vpc_security_group.example.id ]
    nat                = var.vm_db_nat
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub/")}"
  }

  allow_stopping_for_update = true
}