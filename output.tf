output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Public IP of the Bastion Host"
}

output "app_private_ip" {
  value       = aws_instance.app.private_ip
  description = "Private IP of the Internal App Server"
}