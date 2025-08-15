variable "certificate_validity_hours" {
  type    = number
  default = 72
}

variable "ciphertrust_manager_ami_id" {
  type    = string
  default = "ami-0b666be4b385315f7"
}

variable "ciphertrust_manager_instance_type" {
  type    = string
  default = "t2.xlarge"
}

variable "cloudhsm_client_instance_type" {
  type    = string
  default = "t2.micro"
}