variable "yc_folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "yc_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "nat_image_id" {
  description = "ID образа для NAT-инстанса"
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
}
