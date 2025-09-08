# Variables
variable "rgname" {
  type = string
}
variable "location" {
  type = string
}

variable "lawname" {
  type    = string
  default = "mylaw"
}

variable "acrname" {
  type    = string
  default = "myregistry1l90"
}

variable "acrrg" {
  type    = string
  default = "ch08acr-rg"
}
