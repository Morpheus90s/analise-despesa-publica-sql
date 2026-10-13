```sql
-- sql/01_testes_validacao.sql
-- Objetivo: validar integridade, agregações e totais da base sintética.
-- ATENÇÃO: os resultados não representam dados reais de despesas públicas.


-- ============================================================
-- TESTE 0 — Conferir a quantidade de registros carregados
-- Esperado: 12 empenhos, 18 liquidações e 19 pagamentos.
-- ============================================================

SELECT 'empenho' AS tabela, COUNT(*) AS total FROM empenho
UNION ALL
SELECT 'liquidacao_nota_fiscal', COUNT(*) FROM liquidacao_nota_fiscal
UNION ALL
SELECT 'pagamento', COUNT(*) FROM pagamento;


-- ============================================================
-- TESTE 1 — Liquidações órfãs
-- Uma liquidação é órfã quando seu id_empenho não existe
-- na tabela empenho.
-- Esperado: EMP-998.
-- ============================================================

SELECT
    l.id_liquidacao_empenhonotafiscal,
    l.chave_danfe,
    l.id_empenho,
    l.data_emissao,
    l.valor
FROM liquidacao_nota_fiscal AS l
WHERE NOT EXISTS (
    SELECT 1
    FROM empenho AS e
    WHERE e.id_empenho = l.id_empenho
)
ORDER BY l.id_empenho;


-- ============================================================
-- TESTE 2 — Pagamentos órfãos
-- Um pagamento é órfão quando seu id_empenho não existe
-- na tabela empenho.
-- Esperado: EMP-997.
-- ============================================================

SELECT
    p.id_pagamento,
    p.id_empenho,
    p.data_pagamento,
    p.valor
FROM pagamento AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM empenho AS e
    WHERE e.id_empenho = p.id_empenho
)
ORDER BY p.id_empenho;


-- ============================================================
-- TESTE 3 — Empenhos cujo total liquidado supera o empenhado
-- Esperado: EMP-002 e EMP-008.
-- O total é calculado antes do JOIN para evitar duplicações.
-- ============================================================

WITH total_liquidado AS (
    SELECT
        id_empenho,
        SUM(valor) AS valor_liquidado
    FROM liquidacao_nota_fiscal
    GROUP BY id_empenho
)
SELECT
    e.id_empenho,
    e.valor AS valor_empenhado,
    tl.valor_liquidado,
    tl.valor_liquidado - e.valor AS diferenca
FROM empenho AS e
JOIN total_liquidado AS tl
    ON tl.id_empenho = e.id_empenho
WHERE tl.valor_liquidado > e.valor
ORDER BY diferenca DESC;


-- ============================================================
-- TESTE 4 — Comparar empenhado, liquidado e pago
-- Cada tabela de movimento é agregada separadamente.
-- Isso evita multiplicação de linhas ao juntar várias
-- liquidações com vários pagamentos do mesmo empenho.
--
-- Conferir especialmente:
-- EMP-003: pago maior que liquidado.
-- EMP-005: múltiplas liquidações e pagamentos.
-- ============================================================

WITH total_liquidado AS (
    SELECT
        id_empenho,
        SUM(valor) AS valor_liquidado,
        COUNT(*) AS qtd_liquidacoes
    FROM liquidacao_nota_fiscal
    GROUP BY id_empenho
),
total_pago AS (
    SELECT
        id_empenho,
        SUM(valor) AS valor_pago,
        COUNT(*) AS qtd_pagamentos
    FROM pagamento
    GROUP BY id_empenho
)
SELECT
    e.id_empenho,
    e.valor AS valor_empenhado,
    COALESCE(tl.valor_liquidado, 0) AS valor_liquidado,
    COALESCE(tp.valor_pago, 0) AS valor_pago,
    COALESCE(tl.qtd_liquidacoes, 0) AS qtd_liquidacoes,
    COALESCE(tp.qtd_pagamentos, 0) AS qtd_pagamentos,
    COALESCE(tl.valor_liquidado, 0)
        - COALESCE(tp.valor_pago, 0) AS saldo_liquidado_nao_pago
FROM empenho AS e
LEFT JOIN total_liquidado AS tl
    ON tl.id_empenho = e.id_empenho
LEFT JOIN total_pago AS tp
    ON tp.id_empenho = e.id_empenho
ORDER BY e.id_empenho;


-- ============================================================
-- TESTE 4B — Verificar se o JOIN direto inflaria os totais
-- Mostra somente empenhos com múltiplas liquidações E
-- múltiplos pagamentos. Compare os valores corretos,
-- agregados separadamente, com o resultado do JOIN direto.
-- ============================================================

WITH liquidado AS (
    SELECT id_empenho, SUM(valor) AS total_liquidado, COUNT(*) AS qtd_l
    FROM liquidacao_nota_fiscal
    GROUP BY id_empenho
),
pago AS (
    SELECT id_empenho, SUM(valor) AS total_pago, COUNT(*) AS qtd_p
    FROM pagamento
    GROUP BY id_empenho
),
join_direto AS (
    SELECT
        l.id_empenho,
        SUM(l.valor) AS liquidado_com_join,
        SUM(p.valor) AS pago_com_join
    FROM liquidacao_nota_fiscal AS l
    JOIN pagamento AS p
        ON p.id_empenho = l.id_empenho
    GROUP BY l.id_empenho
)
SELECT
    l.id_empenho,
    l.qtd_l,
    p.qtd_p,
    l.total_liquidado AS liquidado_correto,
    j.liquidado_com_join,
    p.total_pago AS pago_correto,
    j.pago_com_join
FROM liquidado AS l
JOIN pago AS p
    ON p.id_empenho = l.id_empenho
JOIN join_direto AS j
    ON j.id_empenho = l.id_empenho
WHERE l.qtd_l > 1
  AND p.qtd_p > 1
ORDER BY l.id_empenho;


-- ============================================================
-- TESTE 5 — Pagamentos de empenhos sem nenhuma liquidação
-- Inclui empenhos existentes sem liquidações e pagamentos
-- órfãos, caso não exista liquidação para aquele id_empenho.
-- Esperado: pagamentos de EMP-004 e EMP-997, conforme a base.
-- ============================================================

SELECT
    p.id_pagamento,
    p.id_empenho,
    p.data_pagamento,
    p.valor
FROM pagamento AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM liquidacao_nota_fiscal AS l
    WHERE l.id_empenho = p.id_empenho
)
ORDER BY p.id_empenho, p.data_pagamento;


-- ============================================================
-- TESTE 6 — Totais mensais por tipo de movimentação
-- Agrupa cada tabela separadamente para não misturar
-- nem multiplicar valores de tabelas diferentes.
-- ============================================================

SELECT
    'empenhado' AS tipo,
    DATE_TRUNC('month', data_empenho)::DATE AS mes,
    COUNT(*) AS quantidade_registros,
    SUM(valor) AS valor_total
FROM empenho
GROUP BY 1, 2

UNION ALL

SELECT
    'liquidado',
    DATE_TRUNC('month', data_emissao)::DATE,
    COUNT(*),
    SUM(valor)
FROM liquidacao_nota_fiscal
GROUP BY 1, 2

UNION ALL

SELECT
    'pago',
    DATE_TRUNC('month', data_pagamento)::DATE,
    COUNT(*),
    SUM(valor)
FROM pagamento
GROUP BY 1, 2

ORDER BY mes, tipo;


-- ============================================================
-- TESTE 7 — Totais anuais por tipo de movimentação
-- ============================================================

SELECT
    'empenhado' AS tipo,
    EXTRACT(YEAR FROM data_empenho)::INTEGER AS ano,
    COUNT(*) AS quantidade_registros,
    SUM(valor) AS valor_total
FROM empenho
GROUP BY 1, 2

UNION ALL

SELECT
    'liquidado',
    EXTRACT(YEAR FROM data_emissao)::INTEGER,
    COUNT(*),
    SUM(valor)
FROM liquidacao_nota_fiscal
GROUP BY 1, 2

UNION ALL

SELECT
    'pago',
    EXTRACT(YEAR FROM data_pagamento)::INTEGER,
    COUNT(*),
    SUM(valor)
FROM pagamento
GROUP BY 1, 2

ORDER BY ano, tipo;


-- ============================================================
-- TESTE 8 — Resumo geral para conferência manual
-- Estes totais incluem todos os registros de cada tabela,
-- inclusive registros órfãos. Isso é intencional para que
-- possamos conferir exatamente o conteúdo carregado.
-- ============================================================

SELECT
    'empenhado' AS tipo,
    COUNT(*) AS quantidade_registros,
    SUM(valor) AS valor_total
FROM empenho

UNION ALL

SELECT
    'liquidado',
    COUNT(*),
    SUM(valor)
FROM liquidacao_nota_fiscal

UNION ALL

SELECT
    'pago',
    COUNT(*),
    SUM(valor)
FROM pagamento;
```