variable "location" {
    default = "ap-south-1"

}

variable "os-name" {
     default = "ami-0da59f1af71ea4ad2"
}

variable "instance-type" {
    default = "t2.small"
}

variable "key" {
    default = "terraform_key"
  
}

variable "vpc-cidr" {
    default = "10.10.0.0/16"
  
}

variable "subnet1-cidr" {
    default = "10.10.1.0/24"
}

variable "subnet-az" {
    default = "ap-south-1a"
  
}