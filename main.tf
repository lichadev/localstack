resource "aws_vpc" "vpc_development"{
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "development-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public_subnet"{
  vpc_id = aws_vpc.vpc_development.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"

  tags = {
    Name = "devsubnet-public"
  }
}

resource "aws_internet_gateway" "mtc_internet_gw" {
  vpc_id = aws_vpc.vpc_development.id
  tags = {
    Name = "mtc-gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_development.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.mtc_internet_gw.id
}
