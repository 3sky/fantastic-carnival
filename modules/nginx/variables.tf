variable "env" {
  description = "use a env placeholder for names"
  type        = string
}

variable "ha" {
  description = "use ha for apps"
  type        = bool
}

variable "region" {
  description = "set a region"
  type        = string
}

variable "vm_shape" {
  description = "shape of the VM"
  type        = string
}

variable "tags" {
  description = "Tags to set for all resources"
  type        = list
}
