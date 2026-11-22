# Declara as variaveis do Terraform
# Regiao da AWS. Usada no provider
variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

# Ambiente de destino
variable "environment" {
  description = "Ambiente de destino: dev, homolog ou prod"
  type        = string

  # Se ninguem escolher, usa dev: o mais seguro para erros
  default = "dev"
}

# Confere o valor ANTES de criar qualquer recurso. Se nao for
# um dos tres ambientes, a execucao para com a mensagem abaixo
validation {
  condition     = contains(["dev", "homolog", "prod"], var.environment)
  error_message = "O environment deve ser dev, homolog ou prod."
}