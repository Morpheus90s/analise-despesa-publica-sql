
-- =========================================================
-- Projeto: Análise de Despesas Públicas
-- Arquivo: questao_4_historico_temporal.sql
--
-- Objetivo:
-- Analisar a evolução temporal de empenhos, liquidações
-- e pagamentos para preparar os dados do Power BI.
--
-- IMPORTANTE:
-- Cada etapa usa sua própria data de referência.
-- Os resultados precisam ser validados na base original.
-- =========================================================


-- =========================================================
-- CONSULTA 1:
-- Qual é o período coberto pelos dados?
--
-- Verifica as datas mínima e máxima de cada etapa.
-- =========================================================

SELECT
    'Empenhos' AS etapa,
    MIN(data_empenho) AS primeira_data,
    MAX(data_empenho) AS ultima_data,
    COUNT(*) AS quantidade_registros
FROM empenho

UNION ALL

SELECT
    'Liquidacoes' AS etapa,
    MIN(data_emissao) AS primeira_data,
    MAX(data_emissao) AS ultima_data,
    COUNT(*) AS quantidade_registros
FROM liquidacao_nota_fiscal

UNION ALL

SELECT
    'Pagamentos' AS etapa,
    MIN(data_pagamento) AS primeira_data,
    MAX(data_pagamento) AS ultima_data,
    COUNT(*) AS quantidade_registros
FROM pagamento;


-- =========================================================
-- CONSULTA 2:
-- Qual é a evolução mensal dos empenhos?
--
-- Agrupa os registros pelo mês da data do empenho.
-- =========================================================

SELECT
    DATE_TRUNC('month', data_empenho)::date AS mes,
    COUNT(*) AS quantidade_empenhos,
    SUM(valor) AS total_empenhado,
    AVG(valor) AS valor_medio_empenho
FROM empenho
WHERE data_empenho IS NOT NULL
GROUP BY DATE_TRUNC('month', data_empenho)
ORDER BY mes;


-- =========================================================
-- CONSULTA 3:
-- Qual é a evolução mensal das liquidações?
--
-- Usa a data de emissão da liquidação.
-- =========================================================

SELECT
    DATE_TRUNC('month', data_emissao)::date AS mes,
    COUNT(*) AS quantidade_liquidacoes,
    SUM(valor) AS total_liquidado,
    AVG(valor) AS valor_medio_liquidacao
FROM liquidacao_nota_fiscal
WHERE data_emissao IS NOT NULL
GROUP BY DATE_TRUNC('month', data_emissao)
ORDER BY mes;


-- =========================================================
-- CONSULTA 4:
-- Qual é a evolução mensal dos pagamentos?
--
-- Usa a data efetiva registrada para o pagamento.
-- =========================================================

SELECT
    DATE_TRUNC('month', data_pagamento)::date AS mes,
    COUNT(*) AS quantidade_pagamentos,
    SUM(valor) AS total_pago,
    AVG(valor) AS valor_medio_pagamento
FROM pagamento
WHERE data_pagamento IS NOT NULL
GROUP BY DATE_TRUNC('month', data_pagamento)
ORDER BY mes;


-- =========================================================
-- CONSULTA 5:
-- Como os totais de cada etapa evoluem por ano?
--
-- As tabelas são agregadas separadamente para evitar
-- multiplicação de valores por relacionamentos 1:N.
--
-- Cada total segue a data da sua própria etapa.
-- =========================================================

WITH empenhos_anuais AS (
    SELECT
        EXTRACT(YEAR FROM data_empenho)::int AS ano,
        COUNT(*) AS quantidade_empenhos,
        SUM(valor) AS total_empenhado
    FROM empenho
    WHERE data_empenho IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM data_empenho)
),
liquidacoes_anuais AS (
    SELECT
        EXTRACT(YEAR FROM data_emissao)::int AS ano,
        COUNT(*) AS quantidade_liquidacoes,
        SUM(valor) AS total_liquidado
    FROM liquidacao_nota_fiscal
    WHERE data_emissao IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM data_emissao)
),
pagamentos_anuais AS (
    SELECT
        EXTRACT(YEAR FROM data_pagamento)::int AS ano,
        COUNT(*) AS quantidade_pagamentos,
        SUM(valor) AS total_pago
    FROM pagamento
    WHERE data_pagamento IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM data_pagamento)
),
anos AS (
    SELECT ano FROM empenhos_anuais
    UNION
    SELECT ano FROM liquidacoes_anuais
    UNION
    SELECT ano FROM pagamentos_anuais
)
SELECT
    a.ano,

    COALESCE(e.quantidade_empenhos, 0)
        AS quantidade_empenhos,
    e.total_empenhado,

    COALESCE(l.quantidade_liquidacoes, 0)
        AS quantidade_liquidacoes,
    l.total_liquidado,

    COALESCE(p.quantidade_pagamentos, 0)
        AS quantidade_pagamentos,
    p.total_pago

FROM anos AS a
LEFT JOIN empenhos_anuais AS e
    ON a.ano = e.ano
LEFT JOIN liquidacoes_anuais AS l
    ON a.ano = l.ano
LEFT JOIN pagamentos_anuais AS p
    ON a.ano = p.ano
ORDER BY a.ano;


-- =========================================================
-- CONSULTA 6:
-- Como os valores empenhados se distribuem por entidade?
--
-- A tabela de empenho contém id_entidade.
-- Esta análise ajuda a identificar concentração de gastos.
-- =========================================================

SELECT
    id_entidade,
    COUNT(*) AS quantidade_empenhos,
    SUM(valor) AS total_empenhado,
    AVG(valor) AS valor_medio_empenho
FROM empenho
GROUP BY id_entidade
ORDER BY total_empenhado DESC
LIMIT 20;
