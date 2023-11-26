variable "project_prefix" {
  type        = string
  default     = "f5xc"
}

variable "deployment" {
  type        = string
  default     = "f5xc"
}

variable "owner_tag" {
  type        = string
  default     = "user@email"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_api_ca_cert" {
  type = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "vsphere_server" {
  type = string
  default = ""
}
variable "vsphere_user" {
  type = string
  default = "administrator@vsphere.local"
}
variable "vsphere_password" {
  type = string
  default = ""
}
variable "vsphere_datacenter" {
  type = string
  default = ""
}
variable "vsphere_cluster" {
  type = string
  default = ""
}
variable "vsphere_datastore" {
  type = string
  default = "datastore1"
}
variable "vsphere_host" {
  type = string
}
variable "f5xc_vm_template" {
  type = string
  default = ""
}
variable "f5xc_vm_guest_type" {
  type = string
}

variable "f5xc_reg_url" {
  type = string
  default = "ves.volterra.io"
}

variable "admin_password" {
  type = string
  default = ""
}
variable "global_virtual_networks" {
  type = list(string)
  default = []
}
