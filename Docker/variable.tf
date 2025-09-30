variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "apps" {
  default = [
    "app-task1",
    "app-task2",
  ]
}