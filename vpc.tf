#STEP 1: create vpc
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyTerraformVPC"
  }
}
#STEP 2: Create a public subnet
resource "aws_subnet" "PublicSubnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.myvpc.id
}
#STEP 3: Create a private subnet
resource "aws_subnet" "PrivateSubnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.myvpc.id
}
#STEP 4: Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}
#STEP 5: Create route tables for public subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#STEP 6: Route tables and associate it with public subnet
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}

