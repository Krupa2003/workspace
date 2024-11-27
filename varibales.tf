variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
}

variable "key_name" {
  description = "The key pair name to use for EC2 instances"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for resources"
  type        = string
}
