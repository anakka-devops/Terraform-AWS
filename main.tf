resource "aws_instance" "web" {
  ami             = "ami-0dbc3d7bc646e8516" #Amazon Linux AMI
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.TF_SG.name]

  #To spin multiple instances
  #count           = 2

  #Key Pair: First method if we create key pair on AWS and can call it from here
  #key_name="demo" 
  # ssh ec2-user@18.236.224.178 -i demo.pem 
  # chmod 400 demo.pem #if we get any permisssion issue

  tags = {
    Name = "Terraform Ec2"
  }
}

#second method if we create key pair in this file
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}
# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#create local folder for pem file
resource "local_file" "TF_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}
# once we have tfkey use ssh: ssh ec2-user@18.212.210.55 -i tfkey
# chmod 400 tfkey #if we get any permisssion issue

#securitygroup using Terraform

resource "aws_security_group" "TF_SG" {
  name        = "security group using Terraform"
  description = "security group using Terraform"
  vpc_id      = "vpc-2dd52950"

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
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
    Name = "TF_SG"
  }
}
