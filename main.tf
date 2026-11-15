terraform {
  required_providers {
    【entity-aws¦canonical_name=aws】 = {
      source  = "hashicorp/ 【entity-aws¦canonical_name=aws】"
      version = "~> 5.0"
    }
  }
}

provider " 【entity-aws¦canonical_name=aws】" {
  region = "ap-south-1"
}

# 【entity-Amazon¦canonical_name=Amazon】 Linux 2023 - isme ec2-user aata hai
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["【entity-amazon¦canonical_name=Amazon】"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "small-server-vpc" }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "small-server-subnet" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "small-server-igw" }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "small-server-route" }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
  name   = "small-server-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "small-server-sg" }
}

resource "aws_instance" "small_server_project" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = { Name = "small-server-project" }
}

output "public_ip" {
  value = aws_instance.small_server_project.public_ip
}