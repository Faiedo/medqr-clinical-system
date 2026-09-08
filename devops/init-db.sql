-- ==============================================================================
-- Script de Inicialização do Banco de Dados PostgreSQL - MedQR
-- Modelagem DER aprovada na Fase 1
-- ==============================================================================

-- Tabela de Usuários (Trabalhadores cadastrados)
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Fichas Clínicas (Dados Médicos de Emergência)
CREATE TABLE IF NOT EXISTS fichas_clinicas (
    id_ficha SERIAL PRIMARY KEY,
    id_usuario INT UNIQUE NOT NULL,
    sexo VARCHAR(20) NOT NULL,
    tipo_sanguineo VARCHAR(5) NOT NULL,
    contato_emergencia VARCHAR(150) NOT NULL,
    alergias TEXT,
    medicamentos TEXT,
    doencas TEXT,
    cirurgias TEXT,
    senha_publica_hash VARCHAR(255) NOT NULL,
    token_emergencia VARCHAR(64) UNIQUE NOT NULL,
    data_atualizacao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_ficha FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- Índices de performance para busca em emergência
CREATE INDEX IF NOT EXISTS idx_token_emergencia ON fichas_clinicas(token_emergencia);
CREATE INDEX IF NOT EXISTS idx_usuario_email ON usuarios(email);

-- Inserção de registro de demonstração para testes de homologação
INSERT INTO usuarios (nome, sobrenome, email, senha_hash)
VALUES ('Samuel', 'Aiedo', 'samuel.aiedo@empresa.com', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW')
ON CONFLICT (email) DO NOTHING;

INSERT INTO fichas_clinicas (
    id_usuario,
    sexo,
    tipo_sanguineo,
    contato_emergencia,
    alergias,
    medicamentos,
    doencas,
    cirurgias,
    senha_publica_hash,
    token_emergencia
)
VALUES (
    1,
    'Masculino',
    'O+',
    '(11) 98765-4321 - Esposa (Maria)',
    'Penicilina, Dipirona',
    'Losartana 50mg (1x ao dia)',
    'Hipertensão Controlada',
    'Apendicectomia (2019)',
    '$2b$10$w8.ZqQd.j/55YgN3UqDye.31iS2F1Z6Rj84k95P4H5J8o0fN3K',
    'medqr_emerg_9988'
)
ON CONFLICT (id_usuario) DO NOTHING;
