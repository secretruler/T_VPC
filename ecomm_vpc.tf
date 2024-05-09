resource "aws_vpc" "ecomm_VPC" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "MAIN-ecomm-VPC"
  }
}

# PUBLIC SUBNET
resource "aws_subnet" "ecomm_web_subnet" {
  vpc_id     = aws_vpc.ecomm_VPC.id
  cidr_block = "10.10.0.0/20"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ecomm-WEB-SUBNET"
  }
}

# PRIVATE SUBNET
resource "aws_subnet" "ecomm_data_subnet" {
  vpc_id     = aws_vpc.ecomm_VPC.id
  cidr_block = "10.10.16.0/20"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "ecomm-DATABASE-SUBNET"
  }
}
# INTERNET GATEWAY
resource "aws_internet_gateway" "ecomm-gateway" {
  vpc_id = aws_vpc.ecomm_VPC.id

  tags = {
    Name = "ecomm-internet-gateway"
  }
}

#ROUTE TABLES
#PUBLIC ROUTE TABLE
resource "aws_route_table" "ecomm_WEB_ROUTE_TABLE" {
  vpc_id = aws_vpc.ecomm_VPC.id


  tags = {
    Name = "ecomm_ROUTE_TABLE-WEB"
  }
}

#Public route table asociation
resource "aws_route_table_association" "web-association" {
  subnet_id      = aws_subnet.ecomm_web_subnet.id
  route_table_id = aws_route_table.ecomm_WEB_ROUTE_TABLE.id
}


#Private  ROUTE TABLE
resource "aws_route_table" "ecomm_DATABASE_ROUTE_TABLE" {
  vpc_id = aws_vpc.ecomm_VPC.id


  tags = {
    Name = "ecomm_ROUTE_TABLE-DATABASE"
  }
}

#Private route table asociation
resource "aws_route_table_association" "database-association" {
  subnet_id      = aws_subnet.ecomm_data_subnet.id
  route_table_id = aws_route_table.ecomm_DATABASE_ROUTE_TABLE.id
}

#  NACL for WEB (public)

resource "aws_network_acl" "WEB_NACL" {
  vpc_id = aws_vpc.ecomm_VPC.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ecomm-WEB-NACL"
  }
}


#PUBLIC NETWORK ACL ASSOICATION
resource "aws_network_acl_association" "ecomm-web-association" {
  network_acl_id = aws_network_acl.WEB_NACL.id
  subnet_id      = aws_subnet.ecomm_web_subnet.id
}



#  NACL for DATABASE (PRIVATE)

resource "aws_network_acl" "DATABASE_NACL" {
  vpc_id = aws_vpc.ecomm_VPC.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ecomm-DATABASE-NACL"
  }
}


#PRIVATE NETWORK ACL ASSOICATION
resource "aws_network_acl_association" "ecomm-database-association" {
  network_acl_id = aws_network_acl.DATABASE_NACL.id
  subnet_id      = aws_subnet.ecomm_data_subnet.id
}


#Security GROUP FOR WEB

resource "aws_security_group" "ecomm-web-sg" {
  name        = "ecomm-web-server-sg"
  description = "Allow web server traffic "
  vpc_id      = aws_vpc.ecomm_VPC.id

  tags = {
    Name = "web-secruity-group"
  }
}

#SSH TRAFFIC
resource "aws_vpc_security_group_ingress_rule" "ecomm-web-ssh" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#HTTP traffic
resource "aws_vpc_security_group_ingress_rule" "ecomm-http-ssh" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}