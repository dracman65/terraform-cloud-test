###################################
## AWS Linux Web Server - Outputs
###################################

output "instance_public_ip" {
  value = aws_instance.linux_ec2.public_ip
}

output "ssh_command" {
  value = "ssh ec2-user@${aws_instance.linux_ec2.public_ip} -i ~/.ssh/id_rsa"
}