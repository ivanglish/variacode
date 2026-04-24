variable "envs" {
  type = map(string)
  default = {
    test = "testing"
    prod = "production"
  }
}

variable "container_port" {
  type = map(number)
  default = {
    test = 80
    prod = 80
  }
}

variable "subnet_cidr_1" {
  type = map(string)
  default = {
    test = "172.31.96.0/24"
    prod = "172.31.98.0/24"
  }
}

variable "subnet_cidr_2" {
  type = map(string)
  default = {
    test = "172.31.97.0/24"
    prod = "172.31.99.0/24"
  }
}