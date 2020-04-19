provider "aws" {
  region = "ap-southeast-1"
}

module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source            = "./modules/lambda"
  lambda_role_arn = module.iam.lambda_role_arn
}