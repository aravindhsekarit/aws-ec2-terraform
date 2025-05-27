provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "testaws" {
  name        = "testaws"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-075686beab831bb7f" # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t2.micro"
  security_groups = [aws_security_group.testaws.name]
  key_name      = "awstest" # Reference your existing key pair name, without .pem

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "Jenkins-innstance"
  }
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.example.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.example.id
}

