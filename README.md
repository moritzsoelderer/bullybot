## BullyBot

This repository contains the source code for a simple discord bot, which allows one to bully your friends with predefined insults.
The bot is not intended to harass strangers, and people in general. Therefore, it is best to keep bullybot on your private server with your friends.

Furthermore, this repo allows for a simple **deployment of bullybot on AWS**, such that bullybot is **always online**, even if your machine is turned off! 
All needed is an AWS account, an installation of terraform (a popular Infrastructure-as-Code tool) and some simple configuration, described in the Setup Guide below.

Naturally, everyone is invited to fork and extend this bot!

## Setup Guide

### Locally
To bring bullybot "online", you can simply run the `bullybot.py` file with python.
Keep in mind that you need to create a `.env` file that holds your discord bot token. For an example see `sample.env`.

### Cloud
To deploy the bot to a cloud instance, you can find a terraform IaC config file under `infrastructure`.
The config is currently set up for AWS, yet easily set up for other cloud providers as well.
for the config to take effect, one must first install the `aws cli`, and configure it with an access key one can get from aws console's IAM.
In order to allow terraform to execute the code defined in `./infrastructure/main.tf`, terraform needs sufficient permissions from aws. Either the root user is used for terraform, which is not recommended, or a new IAM user, policy and role must be created. An example policy that includes the basic permissions for terraform to execute the script correctly can be found in `./infrastructure/terraform_policy.json`. Naturally, as the terraform user needs some permissions to be able to create roles, policies and users itself, you cannot directly define these resources in terraform in this case.

Also, terraform needs an ssh key pair to tunnel into the instance. This can be created on AWS Console or with the cli tool. If the name of the pair differs from `terraform-key-pair`, one needs to update the name in `./infrastructure/main.tf`.

To deploy the bot, one must install terraform (add it to PATH) and execute the following commands in `./infrastructure`:

- `terraform init`
- `terraform plan`
- `terraform apply`

Now, an EC2 instance should have been created.

**DISCLAIMER:** This setup is configured for eu-north-1 region. Available linux images and instance types may differ depending on your region. To configure your region and other variables, see `./infrastructure/variables.tf` and `./infrastructure/terraform.tfvars`.
