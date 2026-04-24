# Reference your existing VPC
data "aws_vpc" "existing" {
  id = "vpc-c2304ca5"
}

resource "aws_internet_gateway" "main" {
  vpc_id = data.aws_vpc.existing.id

  tags = {
    Name = "main-igw-${terraform.workspace}"
    name = "csgtest"
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.existing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt-${terraform.workspace}"
    name = "csgtest"
  }
}

# Associate the Route Table with Subnet 1
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Associate the Route Table with Subnet 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Create Subnet 1
resource "aws_subnet" "public_1" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = lookup(var.subnet_cidr_1, terraform.workspace)
  availability_zone       = "sa-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-subnet-1-${terraform.workspace}"
    name = "csgtest"
  }
}

# Create Subnet 2
resource "aws_subnet" "public_2" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = lookup(var.subnet_cidr_2, terraform.workspace)
  availability_zone       = "sa-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-subnet-2-${terraform.workspace}"
    name = "csgtest"
  }
}
