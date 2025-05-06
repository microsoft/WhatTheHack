# Variables
variable "rgname" {
  type = string
}
variable "location" {
  type = string
}
variable "saname" {
  type = string
}

variable "geoRedundancy" {
  type    = bool
  default = false
}

variable "containername" {
  type    = string
  default = "mycontainer"
}

