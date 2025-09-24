provider "aws" {
  region = "eu-north-1"
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
  instance_type = "t3.micro"
  key_name      = "terraform-key-pair"           # Replace with your key pair name
  iam_instance_profile   = aws_iam_instance_profile.terraform_profile.name

  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  user_data = <<-EOF
                #!/bin/bash
                # install git & python & pip
                sudo apt update
                sudo apt install git python3 python3-pip -y
                sudo apt install awscli -y

                # get discord bot token from environment
                DISCORD_BOT_TOKEN=$(aws ssm get-parameter --name "DISCORD_BOT_TOKEN" --region eu-north-1 --with-decryption --query "Parameter.Value" --output text)
                export DISCORD_BOT_TOKEN
                
                # checkout repo
                git clone https://github.com/moritzsoelderer/bullybot.git /home/ubuntu/bullybot

                # install requirements
                pip3 install -r /home/ubuntu/bullybot/requirements.txt
                
                # run python script
                python3 /home/ubuntu/bullybot/bullybot.py
                EOF

  tags = {
    Name = "BullyBot-EC2-Instance"
  }
}

output "instance_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}
