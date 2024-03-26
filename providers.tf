# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = "eu-west-3"
  profile = "terraform-user"

}

