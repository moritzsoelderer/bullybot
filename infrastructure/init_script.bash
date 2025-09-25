#!/bin/bash
# install git & python & pip
sudo apt update
sudo apt install git python3 python3-pip -y
sudo apt install awscli -y

# get discord bot token from environment
DISCORD_BOT_TOKEN=$(aws ssm get-parameter --name "DISCORD_BOT_TOKEN" --region ${aws_region} --with-decryption --query "Parameter.Value" --output text)
export DISCORD_BOT_TOKEN

# checkout repo
git clone https://github.com/moritzsoelderer/bullybot.git /home/ubuntu/bullybot

# install requirements
pip3 install -r /home/ubuntu/bullybot/requirements.txt

# run python script
python3 /home/ubuntu/bullybot/bullybot.py