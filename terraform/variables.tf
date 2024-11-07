locals {
  project = replace(var.project, "_", "-")
}

variable "cdn_profile_sku" {
  description = "App function tier"
  type        = string

  default = null
}

variable "function_app_os_type" {
  description = "App function OS type"
  type        = string

  default = null
}

variable "function_app_sku" {
  description = "App function SKU"
  type        = string

  default = null
}

variable "location" {
  type    = string
  description = "Azure region to create resources in"

  default = null
}

variable "project" {
  description = "Project name"
  type        = string

  default = null
}

variable "public_domain" {
  description = "Public domain name"
  type        = string

  default = null
}

variable "tags" {
  description = "Tags to apply to the resource"
  type        = map(string)

  default = {}
}

variable "vnet_cidr" {
  description = "vnet CIDR"
  type        = string

  default = null
}