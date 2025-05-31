################################
## Linux Web Server on AWS
################################

#############################################
## Linux Web Server - Deploy Kay if Needed
#############################################

# Used to deploy a new key pair to AWS. This is optional if you already have a key pair.
# resource "aws_key_pair" "deployer" {
#   key_name   = "Digital_Dave_032724"
#   public_key = file("./aws-pvt-key.ppk") # Ensure this file exists
# }

################################
## AWS Security Group
################################
resource "aws_security_group" "ssh_web_sg" {
  name        = "allow_ssh_web"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.191.83.129/32"] # Replace with your IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

################################
## AWS Instance
################################
resource "aws_instance" "linux_ec2" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"
  #key_name      = aws_key_pair.deployer.key_name
  key_name                    = "Digital_Dave_032724" # Ensure this matches your key pair name in AWS.
  security_groups             = [aws_security_group.ssh_web_sg.name]
  associate_public_ip_address = true

  user_data = file("setup.sh") # Run your script

  tags = {
    Name = "Terraform-Linux-Server"
  }
}