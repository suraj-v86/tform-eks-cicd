output "public_ip" {
    description = "Display the Public IP of EC2 instance"
    value = aws_instance.mywebserver.public_ip  
}
output "account_username" {
    description = "Display the account username of the EC2 instance"
    value       = var.ami_id == "ami-12345678" ? "ec2-user" : "ubuntu"
  
}