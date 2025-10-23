
provider "aws" {
  region = var.aws_region
}

# Key pair (uses local public key)
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "easypay-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "easypay-subnet" }
}

data "aws_availability_zones" "available" {}

# Internet Gateway + route table
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "easypay-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "easypay-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group (allow SSH, K8s ports)
resource "aws_security_group" "node_sg" {
  name        = "easypay-node-sg"
  description = "Allow SSH and Kubernetes traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kube API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "easypay-node-sg" }
}

# Launch template user_data (simple to install python3 for Ansible)
data "template_file" "userdata" {
  template = <<EOF
#!/bin/bash
apt-get update
apt-get install -y python3 python3-apt
EOF
}

# EC2 instances: 1 master & 2 workers
resource "aws_instance" "master" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.node_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  user_data                   = data.template_file.userdata.rendered
  tags = { Name = "easypay-master" }
}

resource "aws_instance" "workers" {
  count                       = var.worker_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.node_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  user_data                   = data.template_file.userdata.rendered
  tags = { Name = "easypay-worker-${count.index + 1}" }
}

# Latest Ubuntu AMI (region safe)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "workers_public_ips" {
  value = aws_instance.workers[*].public_ip
}