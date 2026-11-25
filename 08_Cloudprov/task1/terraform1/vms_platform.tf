###yandex_compute 1
 variable "public_vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}
 variable "public_vm_name" {
  type        = string
  default     = "public_vm"
  description = "yandex_compute_instance platform"
}
 variable "public_vm_platform" {
  type        = string
  default     = "standard-v3"
  description = "yandex_compute_instance platform id"
}
 variable "public_vm_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "yandex_compute_instance zone"
}
# variable "public_vm_core" {
#  type        = number
#  default     = "2"
#  description = "yandex_compute_instance resources cores"
#}
# variable "public_vm_mem" {
#  type        = number
#  default     = "2"
#  description = "yandex_compute_instance resources memory"
#}
# variable "public_vm_crfr" {
#  type        = number
#  default     = "20"
#  description = "yandex_compute_instance resources core_fraction"
#}
 variable "public_vm_preem" {
  type        = bool
  default     = "true"
  description = "yandex_compute_instance resources preemptible"
}

###yandex_compute 2

 variable "private_vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}
 variable "private_vm_name" {
  type        = string
  default     = "private_vm"
  description = "yandex_compute_instance platform"
}
 variable "private_vm_platform" {
  type        = string
  default     = "standard-v3"
  description = "yandex_compute_instance platform id"
}
 variable "private_vm_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "yandex_compute_instance zone"
}
# variable "private_vm_core" {
#  type        = number
#  default     = "2"
#  description = "yandex_compute_instance resources cores"
#}
# variable "private_vm_mem" {
#  type        = number
#  default     = "2"
#  description = "yandex_compute_instance resources memory"
#}
# variable "private_vm_crfr" {
#  type        = number
#  default     = "20"
#  description = "yandex_compute_instance resources core_fraction"
#}
 variable "private_vm_preem" {
  type        = bool
  default     = "true"
  description = "yandex_compute_instance resources preemptible"
}
