# Define onde o Terraform guarda o state
terraform {
  backend "s3" {
    # Regiao onde esta o bucket do state
    region = "us-east-1"

    # Lock (trava): impede que duas execucoes alterem o state ao 
    # mesmo tempo. o Terraform cria um arquivo de trava no bucket
    # ao comecar e o apaga ao terminar
    use_lockfile = true

    # Exige que o state seja gravado criptografado no bucket
    encrypt = true
  }
}