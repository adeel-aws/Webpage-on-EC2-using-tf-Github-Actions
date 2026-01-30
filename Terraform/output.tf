output "ec2_ip" {
  description = "The public IP of the web server"
  value       = aws_instance.webserver.public_ip
}

output "instance_url" {
  description = "The clickable URL to view the website"
  value       = "http://${aws_instance.webserver.public_ip}"
}