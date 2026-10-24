# ---------------------------------------
# Input variables
# ---------------------------------------
variable "aws_region" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "project" {
  type    = string
  default = "splunk-app-on-fargate"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "ssh_source_cidr" {
  type        = string
}
