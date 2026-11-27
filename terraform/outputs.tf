output "vm_app_public_ip" {
  description = "IP publico da VM app"
  value       = aws_instance.vm_app.public_ip
}

output "vm_banco_private_ip" {
  description = "IP privado da VM banco"
  value       = aws_instance.vm_banco.private_ip
}