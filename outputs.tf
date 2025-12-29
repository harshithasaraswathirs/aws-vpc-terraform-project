# Outputs - Display important information after deployment

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

output "website_url" {
  description = "URL to access the deployed website"
  value       = "http://${aws_instance.web_server.public_ip}"
}

output "ssh_connection_command" {
  description = "Command to SSH into the server (you'd need a key)"
  value       = "ssh -i your-key.pem ec2-user@${aws_instance.web_server.public_ip}"
}