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

  # Confere o valor ANTES de criar qualquer recurso. Se nao for
  # um dos tres ambientes, a execucao para com a mensagem abaixo
  validation {
    condition     = contains(["dev", "homolog", "prod"], var.environment)
    error_message = "O environment deve ser dev, homolog ou prod."
  }
}

# Chave SSH pública, instalada nas VMs. Vem da Variable
# SSH_PUBLIC_KEY do GitHub. Sem default: é obrigatória
variable "ssh_public_key" {
  description = "Chave SSH pública"
  type        = string
}

# Tamanho das VMS. Corresponde ao parâmetro instance_type
# da pipeline e é a alteração de infraestrutura do Cenário 2
variable "instance_type" {
  description = "Tipo da instancia da VM"
  type        = string
  default     = "t3.micro"

  # Só permite os tamanhos usados no projeto, para proteger
  # os créditos e barrar erros de digitação antes do apply
  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type)
    error_message = "A instancia deve ser t3.micro ou t3.small."
  }
}