variable "environment" {
  description = "Deployment environment"

  type        = object ({
    name           = string
    network_prefix = string
  })
  default = {
    name           = "dev"
    network_prefix = "10.0"
  }
}

variable "vm_size" {
  description = "linux vm size"
  type    = string
  default = "Standard_DS13_v2"
}

variable "storage_account_type" {
  type    = string
  default = "StandardSSD_LRS"
}

variable "storage_account_type" {
  type    = string
  default = "StandardSSD_LRS"
}

variable "disk_size_gb" {
  description = "disk size"
  type        = number
}

variable "subscription_id" {
  description = "azure subscription id"
  type        = string
}

variable "client_id" {
  description = "azure app registition application (clent) id"
  type        = string
}

variable "client_secret" {
  description = "azure app registition client secret (expires every 2 years)"
  type        = string
}

variable "tenant_id" {
  description = "azure app registition directory (tenant) id"
  type        = string
}