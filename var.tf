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
    test = "10.0.1.0/24"
    prod = "10.1.1.0/24"
  }
}

variable "subnet_cidr_2" {
  type = map(string)
  default = {
    test = "10.0.2.0/24"
    prod = "10.1.2.0/24"
  }
}