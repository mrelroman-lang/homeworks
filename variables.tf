###cloud vars 
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "each_vm" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    core_fraction = number
    disk_volume   = number
  }))
  # например:
   default = [
     { vm_name = "main", cpu = 2, ram = 4, core_fraction=20, disk_volume = 10 },
     { vm_name = "replica", cpu = 2, ram = 1, core_fraction=5, disk_volume = 5 }
   ]
}

###yandex_compute
 variable "vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

variable "default_boot_disk" {
  type = object({
    core_fraction = number
    size          = number
    type          = string
  })
  default = {
    core_fraction = 5
    size = 5
    type = "network-hdd"
  }
}

variable "default_vm_instance" {
  type = object({
    disk_type     = string
    disk_size     = number
    platform_id   = string
    preemptible   = bool
    cores         = number
    memory        = number
    core_fraction = number
    nat           = bool
  })
  default = {
    disk_type     = "network-hdd"
    disk_size     = 5
    platform_id   = "standard-v1"
    preemptible   = true
    cores         = 2
    memory        = 1
    core_fraction = 5
    nat           = false
  }
}

variable "vm_db_nat" {
  type        = bool
  default     = "true"
  description = "yandex_compute_instance resources nat"
}

###ssh vars
variable "vm_metadata" {
  type = map(any)
  default = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYhZ8dAy5O/nfvTyx8gBvvoRpqkv8OOWcb/CRR416aJ ubuntu@ubuntu"
  }
}
variable "bastion_vm_name" {
  type   = string
  default = "bastion"
}
variable "bastion_hostname" {
  type   = string
  default = "bastion-hostname"
}
variable "env" {
  type    = string
  default = "production" #создавать ли бастион
}

variable "external_acess_bastion" {
  type    = bool
  default = true #false true создавать ли бастион
}