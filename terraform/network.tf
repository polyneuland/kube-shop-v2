resource "aws_vpc" "vnet" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "kubeshop-${var.environment}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vnet.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "kubeshop-${var.environment}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vnet.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "kubeshop-${var.environment}-private-subnet"
  }
}

resource "aws_internet_gateway" "internet" {
  vpc_id = aws_vpc.vnet.id

  tags = {
    Name = "kubeshop-${var.environment}-internet-gateway"
  }
}

resource "aws_eip" "ip" {
  domain = "vpc"

  tags = {
    Name = "kubeshop-${var.environment}-nat-ip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "kubeshop-${var.environment}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.internet]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vnet.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet.id
  }

  tags = {
    Name = "kubeshop-${var.environment}-public-table"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vnet.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "kubeshop-${var.environment}-private-table"
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}