terraform {
  backend "s3" {
    bucket = "cicd-jenkins-server"
    key    = "EKS/terraform.tfstate"
    region = "us-east-1"

  }
}