variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region"
}
# adjust these values per your deployment and account
variable "aws_access_key" {
  description = "AWS key id"
  default = "Enter Key ID"
}
variable "aws_secret_key" {
  description = "AWS secret key"
  default = "Enter Secret Key"
}
variable "aws_user_prefix" {
  description = "AWS user prefix"
  default = "infra"
}
variable "environment" {
  description = "Name of the environment"
  default = "development"
}
variable "ec2_tags" {
  description = "test"

  default = {
	Name 		    = "Test Terraform"
	Project             = "Special Projects"
    	Environment         = "Development"
    	Contact             = "infra@xyz.com"
}
}

#Collapse
