
-- =========================================================
-- Projeto: Análise de Despesas Públicas
-- Arquivo: 00_base_teste.sql
--
-- ATENÇÃO:
-- Todos os dados deste arquivo são SINTÉTICOS.
-- Não representam transações reais do setor público.
--
-- Objetivos:
-- 1. Recriar a estrutura básica do modelo.
-- 2. Testar consultas SQL de integridade e anomalias.
-- 3. Permitir análises mensais e anuais.
-- 4. Testar relacionamentos 1:N.
--
-- Banco: PostgreSQL
-- =========================================================


-- =========================================================
-- 1. LIMPEZA
-- A execução apaga as tabelas de teste anteriores.
-- NÃO execute em uma base com dados que queira preservar.
-- =========================================================

DROP TABLE IF EXISTS pagamento;
DROP TABLE IF EXISTS liquidacao_nota_fiscal;
DROP TABLE IF EXISTS empenho;


-- =========================================================
-- 2. TABELA DE EMPENHOS
-- =========================================================

CREATE TABLE empenho (
    id_empenho VARCHAR(20) PRIMARY KEY,
    ano INTEGER NOT NULL,
    data_empenho DATE NOT NULL,
    valor NUMERIC(14, 2) NOT NULL CHECK (valor >= 0),
    cpfcnpjcredor VARCHAR(20),
    id_entidade INTEGER,
    id_contrato INTEGER
);


-- =========================================================
-- 3. TABELA DE LIQUIDAÇÕES
--
-- O identificador do empenho não possui FK nesta base
-- de teste para permitir simular registros órfãos e testar
-- as consultas de integridade referencial.
-- =========================================================

CREATE TABLE liquidacao_nota_fiscal (
    id_liquidacao_empenhonotafiscal INTEGER PRIMARY KEY,
    chave_danfe VARCHAR(50),
    data_emissao DATE NOT NULL,
    valor NUMERIC(14, 2) NOT NULL CHECK (valor >= 0),
    id_empenho VARCHAR(20) NOT NULL
);


-- =========================================================
-- 4. TABELA DE PAGAMENTOS
--
-- A ausência intencional de FK permite simular pagamentos
-- sem empenho correspondente.
-- =========================================================

CREATE TABLE pagamento (
    id_pagamento VARCHAR(20) PRIMARY KEY,
    id_empenho VARCHAR(20) NOT NULL,
    data_pagamento DATE NOT NULL,
    valor NUMERIC(14, 2) NOT NULL CHECK (valor >= 0)
);


-- =========================================================
-- 5. DADOS SINTÉTICOS: EMPENHOS
--
-- Há registros distribuídos entre 2024 e 2025 para
-- permitir análises temporais.
-- =========================================================

INSERT INTO empenho (
    id_empenho,
    ano,
    data_empenho,
    valor,
    cpfcnpjcredor,
    id_entidade,
    id_contrato
)
VALUES
('EMP-001', 2024, '2024-01-15', 10000.00, 'CREDOR-001', 101, 5001),
('EMP-002', 2024, '2024-02-10',  5000.00, 'CREDOR-002', 101, 5002),
('EMP-003', 2024, '2024-03-20',  8000.00, 'CREDOR-003', 102, 5003),
('EMP-004', 2024, '2024-04-05',  3500.00, 'CREDOR-004', 102, 5004),
('EMP-005', 2024, '2024-06-12', 12000.00, 'CREDOR-001', 103, 5005),
('EMP-006', 2024, '2024-09-18',  7000.00, 'CREDOR-005', 103, 5006),
('EMP-007', 2025, '2025-01-08', 15000.00, 'CREDOR-002', 101, 5007),
('EMP-008', 2025, '2025-03-14',  6200.00, 'CREDOR-006', 102, 5008),
('EMP-009', 2025, '2025-05-22',  9000.00, 'CREDOR-003', 103, 5009),
('EMP-010', 2025, '2025-07-11',  4500.00, 'CREDOR-004', 101, 5010),
('EMP-011', 2025, '2025-10-02', 11000.00, 'CREDOR-005', 102, 5011),
('EMP-012', 2025, '2025-12-03',  5500.00, 'CREDOR-006', 103, 5012);


-- =========================================================
-- 6. DADOS SINTÉTICOS: LIQUIDAÇÕES
--
-- EMP-001 tem múltiplas liquidações.
-- EMP-002 possui total liquidado superior ao empenhado.
-- EMP-003 tem liquidação parcial.
-- EMP-004 não tem liquidação.
-- EMP-005 tem várias liquidações para testar JOINs.
-- EMP-008 tem total liquidado superior ao empenhado.
-- EMP-012 tem múltiplas liquidações.
-- EMP-998 é um registro órfão intencional para teste.
-- =========================================================

INSERT INTO liquidacao_nota_fiscal (
    id_liquidacao_empenhonotafiscal,
    chave_danfe,
    data_emissao,
    valor,
    id_empenho
)
VALUES
(1,  'DANFE-001', '2024-01-25', 4000.00, 'EMP-001'),
(2,  'DANFE-002', '2024-02-15', 6000.00, 'EMP-001'),

(3,  'DANFE-003', '2024-02-20', 3000.00, 'EMP-002'),
(4,  'DANFE-004', '2024-03-02', 2500.00, 'EMP-002'),

(5,  'DANFE-005', '2024-03-28', 5000.00, 'EMP-003'),

(6,  'DANFE-006', '2024-06-20', 2000.00, 'EMP-005'),
(7,  'DANFE-007', '2024-07-05', 3000.00, 'EMP-005'),
(8,  'DANFE-008', '2024-08-10', 4000.00, 'EMP-005'),

(9,  'DANFE-009', '2024-09-25', 3500.00, 'EMP-006'),

(10, 'DANFE-010', '2025-01-20', 7000.00, 'EMP-007'),

(11, 'DANFE-011', '2025-03-25', 4000.00, 'EMP-008'),
(12, 'DANFE-012', '2025-04-05', 3000.00, 'EMP-008'),

(13, 'DANFE-013', '2025-05-30', 5000.00, 'EMP-009'),

(14, 'DANFE-014', '2025-07-20', 2500.00, 'EMP-010'),

(15, 'DANFE-015', '2025-10-18', 6000.00, 'EMP-011'),

(16, 'DANFE-016', '2025-12-10', 2000.00, 'EMP-012'),
(17, 'DANFE-017', '2025-12-18', 1500.00, 'EMP-012'),

-- Registro órfão intencional:
(18, 'DANFE-018', '2025-11-10', 800.00, 'EMP-998');


-- =========================================================
-- 7. DADOS SINTÉTICOS: PAGAMENTOS
--
-- EMP-001 possui múltiplos pagamentos e liquidações.
-- EMP-003 possui pagamentos superiores à liquidação.
-- EMP-004 possui pagamento sem liquidação.
-- EMP-005 possui múltiplos pagamentos e liquidações.
-- EMP-997 é um pagamento órfão intencional para teste.
-- =========================================================

INSERT INTO pagamento (
    id_pagamento,
    id_empenho,
    data_pagamento,
    valor
)
VALUES
('PAG-001', 'EMP-001', '2024-02-05', 3000.00),
('PAG-002', 'EMP-001', '2024-03-10', 5000.00),
('PAG-003', 'EMP-001', '2024-04-15', 2000.00),

('PAG-004', 'EMP-002', '2024-03-15', 2000.00),
('PAG-005', 'EMP-002', '2024-04-01', 2500.00),

('PAG-006', 'EMP-003', '2024-04-15', 3500.00),
('PAG-007', 'EMP-003', '2024-05-12', 2500.00),

('PAG-008', 'EMP-004', '2024-05-20', 1000.00),

('PAG-009', 'EMP-005', '2024-07-10', 2500.00),
('PAG-010', 'EMP-005', '2024-08-15', 3000.00),
('PAG-011', 'EMP-005', '2024-09-05', 1500.00),

('PAG-012', 'EMP-006', '2024-10-10', 3000.00),

('PAG-013', 'EMP-007', '2025-02-10', 7000.00),

('PAG-014', 'EMP-008', '2025-04-20', 3000.00),

('PAG-015', 'EMP-009', '2025-06-15', 4500.00),

('PAG-016', 'EMP-010', '2025-08-01', 2500.00),

('PAG-017', 'EMP-011', '2025-11-05', 6000.00),

('PAG-018', 'EMP-012', '2025-12-22', 2000.00),

-- Registro órfão intencional:
('PAG-019', 'EMP-997', '2025-11-15', 900.00);


-- =========================================================
-- 8. ÍNDICES
-- Facilitam consultas por empenho e por data.
-- =========================================================

CREATE INDEX idx_liquidacao_id_empenho
    ON liquidacao_nota_fiscal (id_empenho);

CREATE INDEX idx_liquidacao_data_emissao
    ON liquidacao_nota_fiscal (data_emissao);

CREATE INDEX idx_pagamento_id_empenho
    ON pagamento (id_empenho);

CREATE INDEX idx_pagamento_data
    ON pagamento (data_pagamento);

CREATE INDEX idx_empenho_data
    ON empenho (data_empenho);


-- =========================================================
-- 9. CONFERÊNCIA INICIAL
-- Os totais abaixo devem corresponder às linhas inseridas.
-- =========================================================

SELECT
    'empenho' AS tabela,
    COUNT(*) AS quantidade_registros
FROM empenho

UNION ALL

SELECT
    'liquidacao_nota_fiscal',
    COUNT(*)
FROM liquidacao_nota_fiscal

UNION ALL

SELECT
    'pagamento',
    COUNT(*)
FROM pagamento;
