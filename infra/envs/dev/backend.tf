terraform {
  backend "s3" {
    bucket = "REPLACE_WITH_TERRAFORM_STATE_BUCKET"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"

    encrypt = true
  }
}
