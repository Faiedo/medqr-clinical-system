# Security Group for Web Application Server
resource "aws_security_group" "web_sg" {
  name        = "medqr-web-sg"
  description = "Permite trafego HTTP/HTTPS publico para a aplicacao MedQR"
  vpc_id      = aws_vpc.medqr_vpc.id

  ingress {
    description = "HTTP Public Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Public Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Application Node.js/Express Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medqr-web-security-group"
  }
}

# Security Group for RDS PostgreSQL (Private Access Only from Web SG)
resource "aws_security_group" "db_sg" {
  name        = "medqr-db-sg"
  description = "Permite acesso ao PostgreSQL apenas a partir do Security Group da Web App"
  vpc_id      = aws_vpc.medqr_vpc.id

  ingress {
    description     = "PostgreSQL Access from App"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medqr-db-security-group"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "medqr-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "medqr-db-subnet-group"
  }
}

# RDS PostgreSQL Database Instance
resource "aws_db_instance" "postgres" {
  identifier             = "medqr-postgres-db"
  allocated_storage      = 20
  max_allocated_storage  = 50
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "medqr-postgres-instance"
  }
}

# S3 Bucket for Static Assets and QR Codes
resource "aws_s3_bucket" "medqr_assets" {
  bucket = "medqr-app-assets-storage-2026"

  tags = {
    Name = "medqr-s3-assets"
  }
}

# Outputs
output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.medqr_vpc.id
}

output "rds_endpoint" {
  description = "Endpoint de conexao do Banco de Dados PostgreSQL"
  value       = aws_db_instance.postgres.endpoint
}

output "s3_bucket_name" {
  description = "Nome do Bucket S3 para armazenar os QR Codes"
  value       = aws_s3_bucket.medqr_assets.id
}
