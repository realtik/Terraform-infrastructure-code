# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "hugov-terraform-remote-state"
    key            = "terraform-module/pcoterraform/terraform.tfstate"
    region         = "eu-west-3"
    profile        = "terraform-user"
    dynamodb_table = "terraform-state-lock"
  }
}