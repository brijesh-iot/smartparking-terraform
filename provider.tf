provider "aws" {
  version = ">=2.0"
  region  = "us-east-1"
  #shared_credentials_file = "C:/Users/bprajapati/.aws/credentials"
  #profile                 = "cnative"
}

terraform {
  backend "s3" {
    bucket = "smartparking-jenkins-terraform"
    key    = "smartparking-jenkins-terraform.tfstate"
    region = "us-east-1"
  }
}