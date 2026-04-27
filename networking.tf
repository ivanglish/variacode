# 1. Create the VPC (Unique for each workspace)
resource "aws_vpc" "main" {
  cidr_block           = local.env_config.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${local.environment_name}"
    name = "csgtest"
  }
}

# 2. Create the Internet Gateway (Dedicated to the VPC above)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw-${local.environment_name}"
    name = "csgtest"
  }
}

# 3. Create the Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt-${local.environment_name}"
    name = "csgtest"
  }
}

# 4. Create Subnets (Referencing the new VPC)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.env_config.subnet_cidr_1
  availability_zone       = "sa-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-subnet-1-${local.environment_name}"
    name = "csgtest"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.env_config.subnet_cidr_2
  availability_zone       = "sa-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-subnet-2-${local.environment_name}"
    name = "csgtest"
  }
}

# 5. Route Table Associations
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}