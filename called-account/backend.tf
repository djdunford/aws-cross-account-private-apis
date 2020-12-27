terraform {
  backend "s3" {
    bucket = "djdunford-traindep-tfstate-eu-west-2"
    key    = "tfstate"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "djdunford-traindep-tfstate-lock"
  }
}