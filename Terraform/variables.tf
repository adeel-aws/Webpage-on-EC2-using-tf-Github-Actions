variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "public_subnet1_cidr_block" {
  default = "10.0.1.0/24"
}

variable "private_subnet1_cidr_block" {
  default = "10.0.3.0/24"
}

variable "Availability_zone1" {
  default = "us-east-1a"
}


variable "key_name" {
  description = "AWS EC2 Key Pair Name"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

variable "ssh_location" {
  description = "The IP address range that can SSH into the EC2 instance"
  type        = string
  default     = "0.0.0.0/0" # Change this to your specific IP (e.g., "1.2.3.4/32") for better security
}