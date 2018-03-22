variable "region" {
  type = "string"
}

variable "size" {
  type = "string"
}

variable "record_name" {
  type = "string"
}

variable "record_domain" {
  type = "string"
}

variable "ssh_fingerprints" {
  type = "list"
}

variable "tags_allowed_to_access" {
  type = "list"
}

variable "password" {
  type = "string"
}

variable "number_of_dbs" {
  default = "16"
  type = "string"
}
