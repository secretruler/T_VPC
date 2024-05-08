resource "aws_vpc" "IBM_VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MAIN-IBM-VPC"
  }
}

# PUBLIC SUBNET
resource "aws_subnet" "ibm_web_subnet" {
  vpc_id     = aws_vpc.IBM_VPC.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "IBM-WEB-SUBNET"
  }
}

# PIVATE SUBNET
resource "aws_subnet" "ibm_data_subnet" {
  vpc_id     = aws_vpc.IBM_VPC.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "IBM-DATABASE-SUBNET"
  }
}

