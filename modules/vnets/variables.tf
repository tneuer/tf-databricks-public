variable "location" {
  type = string
}

variable "project" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "vnet_cidr_range" {
  type = string
}

variable "tags" {
  type = map(any)
}
