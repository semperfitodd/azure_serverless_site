locals {
  project = replace(var.project, "_", "-")
}

variable "cdn_profile_sku" {
  description = "App function tier"
  type        = string

  default = ""
}

variable "function_app_os_type" {
  description = "App function OS type"
  type        = string

  default = ""
}

variable "function_app_sku" {
  description = "App function SKU"
  type        = string

  default = ""
}

variable "project" {
  description = "Project name"
  type        = string

  default = ""
}

variable "public_domain" {
  description = "Public domain name"
  type        = string

  default = ""
}

variable "tags" {
  description = "Tags to apply to the resource"
  type        = map(string)

  default = {}
}

variable "vnet_cidr" {
  description = "vnet CIDR"
  type        = string

  default = ""
}