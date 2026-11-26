resource "aws_key_pair" "ssh" {
  key_name   = "kubeshop-${var.environment}-ssh-key"
  public_key = var.ssh_public_key
}