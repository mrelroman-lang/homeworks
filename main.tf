# создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
#создаем облачную subсеть
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}


###создаем/не создаем бастион
resource "yandex_compute_instance" "bastion" {
  count = alltrue([var.env == "production", var.external_acess_bastion]) ? 1 : 0

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface.0.nat_ip_address
    private_key = file("~/.ssh/id_ed25519")
    timeout     = "120s"
  }
  provisioner "file" {
    source      = "./scripts"
    destination = "/tmp"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/scripts/script.sh",
      "/tmp/scripts/script.sh"
    ]
  }

  name        = var.bastion_vm_name
  hostname    = var.bastion_hostnameB
  platform_id = var.default_vm_instance.platform_id

  resources {
    cores         = var.default_vm_instance.cores
    memory        = var.default_vm_instance.memory
    core_fraction = var.default_vm_instance.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.default_vm_instance.disk_type
      size     = var.default_vm_instance.disk_size
    }
  }

  metadata = var.vm_metadata

  scheduling_policy { preemptible = var.default_vm_instance.preemptible }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.default_vm_instance.nat
  }
  allow_stopping_for_update = true
}