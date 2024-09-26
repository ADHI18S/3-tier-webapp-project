resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "my-vpc-sub-pub" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.24.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "my-vpc-sub-pub"
  }
}


resource "aws_subnet" "my-vpc-sub-pvt" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.26.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "my-vpc-sub-pvt"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-vpc-igw"
  }
}
resource "aws_route_table" "my-vpc-rt-pub" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

 
  tags = {
    Name = "my-vpc-rt-pub"
  }
}

resource "aws_route_table_association" "pubasso" {
  subnet_id      = aws_subnet.my-vpc-sub-pub.id
  route_table_id = aws_route_table.my-vpc-rt-pub.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "my-vpc-nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.my-vpc-sub-pub.id

  tags = {
    Name = "my-vpc-nat"
  }

 
}

resource "aws_route_table" "my-vpc-rt-pvt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-vpc-nat.id
  }

 
  tags = {
    Name = "my-vpc-rt-pvt"
  }
}

resource "aws_route_table_association" "pvtasso" {
  subnet_id      = aws_subnet.my-vpc-sub-pvt.id
  route_table_id = aws_route_table.my-vpc-rt-pvt.id
}
 
resource "aws_security_group" "my-vpc-pub_sg" {
  name        = "pub_security_group"
  description = "Security group for allowing SSH and HTTP traffic"
  vpc_id      = aws_vpc.my-vpc.id

  # Inbound rules
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

   ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pub-sg"
  }
}

resource "aws_instance" "my-vpc-instance" {
  ami           = var.ami[0]
  instance_type = var.instance_type[0]
  subnet_id = aws_subnet.my-vpc-sub-pub.id
  vpc_security_group_ids = [ aws_security_group.my-vpc-pub_sg.id]
  key_name = var.key_name[0]
  associate_public_ip_address = true

  tags = {
    Name = "3_tier_webapp"
  }
}

resource "aws_instance" "my-vpc-instance2" {
  ami           = var.ami[1]
  instance_type = var.instance_type[1]
  subnet_id = aws_subnet.my-vpc-sub-pvt.id
  vpc_security_group_ids = [ aws_security_group.my-vpc-pub_sg.id]
  key_name = var.key_name[1]
  associate_public_ip_address = false

  tags = {
    Name = "3_tier_pvt-webapp"
  }
}
