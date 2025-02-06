variable "ami_id" {
    description = "The value for the aws Instance"  
}
variable "instance_type_value" {
    description = "The value for the instance type"
}
variable "key_value" {
    description = "The value for Key name"
    
}
variable "subnet_id" {
    description = "The value for subnet id"
  
}
variable "cidr" {
    description = "The value for cidr"
  
}
variable "sg_name" {
    description = "The value for security group"
    type = string
  
}
variable "sg_description" {
    description = "The description for the security group"
    type = string
      
}
variable "vpc_id" {
    description = "The value for vpc id"
    type = string
  
}
variable "ingress_rules" {
    description = "List of ingress rules"
    type = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string) 
    }))

    default = [ {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
             
    },
    {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    } ]
}
variable "egress_rules" {
    description = "List of egress rules"
    type = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)

    }))

    default = [ {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]

    } ]
  
}
variable "root_block_device" {
    description = "Size of the root volume in GB"
    type = number
    default = 10
  
}
