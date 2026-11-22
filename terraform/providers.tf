# Define qual provider (plugin) o Terraform usa
# para falar com a nuvem e como ele eh configurado
terraform {
  required_version = ">= 1.10" # Versao minima do Terraform exigida no projeto
  required_providers {         # Providers que o projeto precisa baixar no terraform init
    aws = {
      source  = "hashicorp/aws" # Provider oficial da AWS
      version = "~> 6.0"        # Aceita qualquer versão 6.x
    }
  }
}

# Configuracao do provider da AWS
provider "aws" {
  # Regiao onde os recursos serao criados. Vem de uma variavel
  region = var.aws_region

  # Tags aplicadas automaticamente a TODOS os recursos criados
  default_tags {
    tags = {
      # Texto fixo: identifica o projeto e permite filtrar custos
      Projeto = "pm04"

      # Referencia a variavel: dev, homolog ou prod, vindo da pipeline
      Ambiente = var.environment

      # Texto fixo: aviso que o recurso eh gerenciado pelo Terraform
      # e nao deve ser alterado manualmente no console
      GerenciadoPor = "terraform"
    }
  }
}