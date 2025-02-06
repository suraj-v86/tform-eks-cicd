resource "aws_instance" "mywebserver" {
  ami                     = var.ami_id
  instance_type           = var.instance_type_value
  subnet_id = var.subnet_id
  key_name = var.key_value 
  vpc_security_group_ids = [ aws_security_group.mywebsg.id]

  root_block_device {
    volume_size = var.root_block_device
    volume_type = "gp3"
    delete_on_termination = true
  }

  tags = {
    name = "Mywebserver"
  }
  
  
}
resource "aws_security_group" "mywebsg" {
    name = var.sg_name
    description = var.sg_description
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.ingress_rules
        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }

      
    }
    dynamic "egress" {
        for_each = var.egress_rules
        content {
            from_port = egress.value.from_port
            to_port = egress.value.to_port
            protocol = egress.value.protocol
            cidr_blocks = egress.value.cidr_blocks
        }

    }

    tags = {
        name = var.sg_name
    }
  
}