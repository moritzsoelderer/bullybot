provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_iam_instance_profile" "terraform_profile" {
  name = "terraform-profile"
  role = "terraform-role"
}

# SSH security group
resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.terraform_profile.name

  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  user_data =   templatefile("${path.module}/init_script.bash", {
    aws_region = var.aws_region
  })

  tags = {
    Name = "BullyBot-EC2-Instance"
  }
}

output "instance_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}
