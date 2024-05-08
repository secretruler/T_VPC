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

# PRIVATE SUBNET
resource "aws_subnet" "ibm_data_subnet" {
  vpc_id     = aws_vpc.IBM_VPC.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "IBM-DATABASE-SUBNET"
  }
}
# INTERNET GATEWAY
resource "aws_internet_gateway" "ibm-gateway" {
  vpc_id = aws_vpc.IBM_VPC.id

  tags = {
    Name = "ibm-internet-gateway"
  }
}

#ROUTE TABLES
#PUBLIC ROUTE TABLE
resource "aws_route_table" "IBM_WEB_ROUTE_TABLE" {
  vpc_id = aws_vpc.IBM_VPC.id


  tags = {
    Name = "IBM_ROUTE_TABLE-WEB"
  }
}

#Public route table asociation
resource "aws_route_table_association" "web-association" {
  subnet_id      = aws_subnet.ibm_web_subnet.id
  route_table_id = aws_route_table.IBM_WEB_ROUTE_TABLE.id
}


#Private  ROUTE TABLE
resource "aws_route_table" "IBM_DATABASE_ROUTE_TABLE" {
  vpc_id = aws_vpc.IBM_VPC.id


  tags = {
    Name = "IBM_ROUTE_TABLE-DATABASE"
  }
}

#Private route table asociation
resource "aws_route_table_association" "database-association" {
  subnet_id      = aws_subnet.ibm_data_subnet.id
  route_table_id = aws_route_table.IBM_DATABASE_ROUTE_TABLE.id
}


