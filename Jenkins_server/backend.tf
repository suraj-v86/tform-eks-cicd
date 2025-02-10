terraform {
  backend "s3" {
    bucket = "cicd-jenkins-server"
    key    = "Jenkins/terraform.tfstate"
    region = "us-east-1"

  }
}