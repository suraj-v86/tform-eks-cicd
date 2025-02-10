variable "aws_region" {
  description = "aws region"

}
variable "vpc_cidr" {
  description = "value for vpc cidr"
  type        = string
}

variable "private_subnets" {
  description = "value for private subnets"
  type        = list(string)

}

variable "instance_type" {
  description = "value for node instance type"
  type        = list(string)

}

variable "public_subnets" {
  description = "value for public subnets of vpc"
  type        = list(string)

}



  