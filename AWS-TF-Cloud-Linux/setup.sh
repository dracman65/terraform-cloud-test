#!/bin/bash
# Install and start nginx
yum update -y
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx
echo "Hello from Terraform provisioned EC2 via a Terraform/Bash SSH Script!" > /usr/share/nginx/html/index.html