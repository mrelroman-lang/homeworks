###3disks
resource "yandex_compute_disk" "disks" {
  count = 3
 
  name = "disk-${count.index + 1}"
  type = var.default_vm_instance.disk_type
  size = "1"  # Размер 1 ГБ
}

###1Vm
resource "yandex_compute_instance" "storage" {

  name        = "storage"
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
   dynamic secondary_disk{
    for_each  = yandex_compute_disk.disks[*].id
    content {
      disk_id     = secondary_disk.value
      auto_delete = true
    }
  }

  scheduling_policy {
    preemptible = var.default_vm_instance.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [ yandex_vpc_security_group.example.id]
    nat                = var.default_vm_instance.nat
  }

  metadata = var.vm_metadata
 }

