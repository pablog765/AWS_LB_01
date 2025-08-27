# variables.tf

variable "aws_region" {
  description = "La región de AWS donde se desplegarán los recursos."
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "El ID de la AMI para las instancias EC2."
  type        = string
  default     = "ami-0c1bd87e5f5936ac0" # AMI de Amazon Linux 2 en us-east-1
}

variable "instance_type" {
  description = "El tipo de instancia para las EC2."
  type        = string
  default     = "t2.micro"
}

variable "vpc_cidr_block" {
  description = "CIDR block para la VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_a_cidr_block" {
  description = "CIDR block para la subred A."
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr_block" {
  description = "CIDR block para la subred B."
  type        = string
  default     = "10.0.2.0/24"
}