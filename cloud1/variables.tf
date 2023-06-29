variable "username_tf" {
  type = string
  default = ""
}

variable "password_tf" {
  type = string
  default = ""
}

variable "project_id_tf" {
  type = string
  default = ""
}

variable "image_flavor" {
  type = string
  default = "Debian11.4"
}

variable "compute_flavor" {
  type = string
  default = "Basic-1-2-20"
}

variable "availability_zone_name" {
  type = string
  default = "MS1"
}
