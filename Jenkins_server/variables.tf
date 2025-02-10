variable "aws_region" {
  description = "aws region"
}

variable "vpc_cidr" {
  description = "value for vpc cidr"
  type        = string
}

variable "public_subnets" {
  description = "value for public subnets of vpc"
  type        = list(string)

}

variable "instance_type" {
  description = "value for instance type"
  type        = string

}
variable "key_value" {
  description = "value key pair"
}