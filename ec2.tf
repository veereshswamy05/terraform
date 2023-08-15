provider "aws" {
    region = var.location
  
}

resource "aws_instance" "demo-server" {

  ami           = var.os-name
  key_name      = var.key  
  instance_type = var.instance-type
  availability_zone = "ap-south-1a"
  subnet_id = aws_subnet.demo-subnet.id
  vpc_security_group_ids = [aws_security_group.demo-vpc-sg.id]


  tags = {
    Name = "MyEC2Instance"
  }

  associate_public_ip_address = true  # This enables a public IP for the instance
  
}

// Create VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc-cidr
}

// Create Subnet

resource "aws_subnet" "demo-subnet" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.vpc-cidr
  availability_zone = var.subnet-az

  tags = {
    Name = "demo_subnet"
  }
}

// Create Internet gateway

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

// Create Route table

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }



  tags = {
    Name = "demo-rt"
  }
}

// Create Subnet Association

resource "aws_route_table_association" "demo-rt_association" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-rt.id
}


// Create security Groups

resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


