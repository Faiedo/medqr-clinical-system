variable "aws_region" {
  description = "Regiao AWS para provisionamento da infraestrutura"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de execucao (dev, staging, prod)"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC do MedQR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_name" {
  description = "Nome do Banco de Dados PostgreSQL"
  type        = string
  default     = "medqr_db"
}

variable "db_username" {
  description = "Usuario administrador do Banco de Dados"
  type        = string
  default     = "medqr_admin"
}

variable "db_password" {
  description = "Senha do Banco de Dados PostgreSQL (injetada via Secret/Var)"
  type        = string
  sensitive   = true
  default     = "MedQR_SuperSecure_Pass2026!"
}
