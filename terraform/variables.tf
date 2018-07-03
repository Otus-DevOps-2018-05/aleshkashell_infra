variable "project" {
  description = "Project ID"
}

variable "region" {
  description = "Region"
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable "public_key_path" {
  description = "Path to public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to private key used for ssh access"
}

variable "disk_image" {
  description = "Disk image"
}

variable "count" {
  description = "Count of instance"
}
