# Code to create vpc with cidr range
resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "github-vpc"
  }

}

# code to create web server subnet
resource "aws_subnet" "public-SN1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-github-staging-SN1"
  }

}

# code to create public subnet2
resource "aws_subnet" "public-SN2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-github-production-SN2"
  }
}

# code to create private subnet
resource "aws_subnet" "private-SN1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-github-SN1"
  }
}

# code to create private subnet
resource "aws_subnet" "private-SN2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-github-SN2"
  }
}

# code to create internet gateway
resource "aws_internet_gateway" "main-IGW" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "github-IGW"
  }
}

# code to provision elastic ip for nat gateway
# Allocate Elastic IP Address for Nat-Gateway
resource "aws_eip" "main-NAT-EIP" {
  vpc = true

  tags = {
    "Name" = "github-NAT-EIP"
  }

}

# Create Nat Gateway
resource "aws_nat_gateway" "main-NAT" {
  allocation_id = aws_eip.main-NAT-EIP.id
  subnet_id     = aws_subnet.public-SN1.id

  tags = {
    "Name" = "github-NAT"
  }

}

# Create Private Route Table and configure route
resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main-NAT.id
  }

  tags = {
    "Name" = "private-github-RT"
  }

}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private-mobikart-SN1-association" {
  subnet_id      = aws_subnet.private-SN1.id
  route_table_id = aws_route_table.private-RT.id
}
resource "aws_route_table_association" "private-mobikart-SN2-association" {
  subnet_id      = aws_subnet.private-SN2.id
  route_table_id = aws_route_table.private-RT.id
}

# Create Public Route Table and Configure Route
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-IGW.id
  }

  tags = {
    "Name" = "public-github-RT"
  }

}

# Associate Public Route Table with Public subnet 
resource "aws_route_table_association" "public-SN-association" {
  subnet_id      = aws_subnet.public-SN1.id
  route_table_id = aws_route_table.public-RT.id
}

# Associate Public Route Table with Public subnet 
resource "aws_route_table_association" "public-SN2-association" {
  subnet_id      = aws_subnet.public-SN2.id
  route_table_id = aws_route_table.public-RT.id
}






