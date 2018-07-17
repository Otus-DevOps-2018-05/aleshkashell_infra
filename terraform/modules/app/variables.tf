variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable "public_key_path" {
  description = "Path to public key used for ssh access"
}

variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "private_key_path" {
  description = "Path to private key"
}

variable "db_ip" {
  description = "IP address of db"
}

variable "need_provision" {
  description = "Condition for provision"
}
