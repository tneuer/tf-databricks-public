variable "location" {
  type = string
}

variable "project" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "db_storage_account_name" {
  type = string
}

variable "db_storage_subnet_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "tags" {
  type = map(any)
}
