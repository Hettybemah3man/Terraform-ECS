# Configure the AWS Provider
provider "aws" {
  region = var.region
}

resource "aws_vpc" "great_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "great-vpc"
  }
}

# Subnet public 1
resource "aws_subnet" "great_pub_sub_1" {
  vpc_id     = aws_vpc.great_vpc.id
  cidr_block = var.great_pub_sub_1_cidr
   availability_zone = "eu-west-1a"

  tags = {
    Name = "great-pub-sub-1"
  }
}

# Subnet public 2
resource "aws_subnet" "great_pub_sub_2" {
  vpc_id     = aws_vpc.great_vpc.id
  cidr_block = var.great_pub_sub_2_cidr
  availability_zone = "eu-west-1b"

  tags = {
    Name = "great-pub-sub-2"
  }
}

# Subnet private 1
resource "aws_subnet" "great_priv_sub_1" {
  vpc_id     = aws_vpc.great_vpc.id
  cidr_block = var.great_priv_sub_1_cidr

  tags = {
    Name = "great-priv-sub-1"
  }
}

# Subnet private 2
resource "aws_subnet" "great_priv_sub_2" {
  vpc_id     = aws_vpc.great_vpc.id
  cidr_block = var.great_priv_sub_2_cidr

  tags = {
    Name = "great-priv-sub-2"
  }
}

# aws Route table Public
resource "aws_route_table" "great_pub_route_table" {
  vpc_id = aws_vpc.great_vpc.id

  tags = {
    Name = "great-pub-route-table"
  }
}

# aws Route table Private
resource "aws_route_table" "great_priv_route_table" {
  vpc_id = aws_vpc.great_vpc.id

  tags = {
    Name = "great-priv-route-table"
  }
}

# Subnet association public1
resource "aws_route_table_association" "great_pub_route_table_association_1" {
  subnet_id      = aws_subnet.great_pub_sub_1.id
  route_table_id = aws_route_table.great_pub_route_table.id
}

# Subnet association public2
resource "aws_route_table_association" "great_pub_route_table_association_2" {
  subnet_id      = aws_subnet.great_pub_sub_2.id
  route_table_id = aws_route_table.great_pub_route_table.id
}

# Subnet association private1
resource "aws_route_table_association" "great_priv_route_table_association_1" {
  subnet_id      = aws_subnet.great_priv_sub_1.id
  route_table_id = aws_route_table.great_priv_route_table.id
}

# Subnet association private2
resource "aws_route_table_association" "great_priv_route_table_association_2" {
  subnet_id      = aws_subnet.great_priv_sub_2.id
  route_table_id = aws_route_table.great_priv_route_table.id
}

# aws IGW
resource "aws_internet_gateway" "great_igw" {
  vpc_id = aws_vpc.great_vpc.id

  tags = {
    Name = "great.igw"
  }
}

# AWs route for great igw & pub route table
resource "aws_route" "great_pub_igw_association" {
  route_table_id = aws_route_table.great_pub_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.great_igw.id
}

# Elastic IP address
resource "aws_eip" "great_eip" {
  
}

# Nat gateway 
resource "aws_nat_gateway" "great_nat_gateway" {
  allocation_id = aws_eip.great_eip.id
  subnet_id     = aws_subnet.great_pub_sub_1.id
  }

# Nat gateway association with priv route table
resource "aws_route" "great_priv_route" {
  route_table_id = aws_route_table.great_priv_route_table.id
  nat_gateway_id            = aws_nat_gateway.great_nat_gateway.id
  destination_cidr_block    = "0.0.0.0/0"
}