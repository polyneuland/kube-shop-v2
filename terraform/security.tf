resource "aws_security_group" "vm_app_group" {
  name        = "kubeshop-${var.environment}-security-group-app"
  description = "Security Group para a VM app"
  vpc_id      = aws_vpc.vnet.id

  ingress {
    description = "Acessar a loja"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Acesso SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Saida liberada"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubeshop-${var.environment}-security-group-app"
  }
}

resource "aws_security_group" "vm_banco_group" {
  name        = "kubeshop-${var.environment}-security-group-banco"
  description = "Security Group para a VM banco"
  vpc_id      = aws_vpc.vnet.id

  ingress {
    description     = "API para acessar o banco"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.vm_app_group.id]
  }

  ingress {
    description     = "Acesso SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.vm_app_group.id]
  }

  egress {
    description = "Saida pelo NAT Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubeshop-${var.environment}-security-group-banco"
  }
}