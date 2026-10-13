
-- =========================================================
-- Projeto: Análise de Despesas Públicas
-- Arquivo: questao_2_anomalias.sql
--
-- Objetivo:
-- Verificar integridade referencial e identificar registros
-- que merecem investigação na execução da despesa pública.
--
-- IMPORTANTE:
-- Os resultados dependem da base de dados utilizada.
-- Diferenças encontradas não comprovam, isoladamente,
-- a existência de irregularidades.
-- =========================================================


-- =========================================================
-- PERGUNTA 1:
-- Existem pagamentos sem empenho correspondente?
--
-- Objetivo:
-- Identificar pagamentos cujo empenho não existe na tabela
-- empenho.
--
-- Resultado anterior informado:
-- Nenhum registro encontrado (validar novamente).
-- =========================================================

SELECT
    p.id_pagamento,
    p.id_empenho,
    p.valor AS valor_pago,
    p.datapagamentoempenho
FROM pagamento AS p
LEFT JOIN empenho AS e
    ON p.id_empenho = e.id_empenho
WHERE e.id_empenho IS NULL
ORDER BY
    p.datapagamentoempenho,
    p.id_pagamento;


-- =========================================================
-- PERGUNTA 2:
-- Existem liquidações sem empenho correspondente?
--
-- Objetivo:
-- Identificar liquidações cujo empenho não existe na tabela
-- empenho.
--
-- Resultado anterior informado:
-- Nenhum registro encontrado (validar novamente).
-- =========================================================

SELECT
    l.id_liquidacao_empenhonotafiscal,
    l.id_empenho,
    l.valor AS valor_liquidado,
    l.data_emissao
FROM liquidacao_nota_fiscal AS l
LEFT JOIN empenho AS e
    ON l.id_empenho = e.id_empenho
WHERE e.id_empenho IS NULL
ORDER BY
    l.data_emissao,
    l.id_liquidacao_empenhonotafiscal;


-- =========================================================
-- PERGUNTA 3:
-- O valor total liquidado supera o valor empenhado?
--
-- Objetivo:
-- Comparar o valor do empenho com a soma das liquidações
-- associadas a ele.
--
-- Melhorias:
-- - Diferença em reais;
-- - Percentual da diferença sobre o valor empenhado;
-- - Ordenação pelos maiores valores liquidados.
--
-- Atenção:
-- A comparação pressupõe que os valores sejam comparáveis
-- e que cancelamentos, ajustes e cobertura temporal tenham
-- sido considerados.
-- =========================================================

WITH liquidacoes AS (
    SELECT
        id_empenho,
        SUM(valor) AS valor_liquidado,
        COUNT(*) AS quantidade_liquidacoes
    FROM liquidacao_nota_fiscal
    GROUP BY id_empenho
)
SELECT
    e.id_empenho,
    e.valor AS valor_empenhado,
    l.valor_liquidado,
    l.quantidade_liquidacoes,
    l.valor_liquidado - e.valor AS diferenca_valor,
    CASE
        WHEN e.valor IS NOT NULL
             AND e.valor <> 0
        THEN
            100.0 * (l.valor_liquidado - e.valor)
            / e.valor
        ELSE NULL
    END AS diferenca_percentual
FROM empenho AS e
INNER JOIN liquidacoes AS l
    ON e.id_empenho = l.id_empenho
WHERE l.valor_liquidado > e.valor
ORDER BY
    diferenca_valor DESC;


-- =========================================================
-- PERGUNTA 4:
-- O valor total pago supera o valor total liquidado?
--
-- Correção importante:
-- As tabelas de liquidações e pagamentos são agregadas
-- separadamente por empenho antes de serem relacionadas.
--
-- Isso evita que múltiplas liquidações combinadas com
-- múltiplos pagamentos multipliquem os valores somados.
--
-- Atenção:
-- A ausência de liquidações na base não significa
-- necessariamente que nenhuma liquidação ocorreu.
-- =========================================================

WITH liquidacoes AS (
    SELECT
        id_empenho,
        SUM(valor) AS valor_liquidado,
        COUNT(*) AS quantidade_liquidacoes
    FROM liquidacao_nota_fiscal
    GROUP BY id_empenho
),
pagamentos AS (
    SELECT
        id_empenho,
        SUM(valor) AS valor_pago,
        COUNT(*) AS quantidade_pagamentos
    FROM pagamento
    GROUP BY id_empenho
)
SELECT
    e.id_empenho,
    e.valor AS valor_empenhado,

    COALESCE(l.valor_liquidado, 0)
        AS valor_liquidado,

    COALESCE(p.valor_pago, 0)
        AS valor_pago,

    COALESCE(p.valor_pago, 0)
        - COALESCE(l.valor_liquidado, 0)
        AS diferenca_valor,

    COALESCE(l.quantidade_liquidacoes, 0)
        AS quantidade_liquidacoes,

    COALESCE(p.quantidade_pagamentos, 0)
        AS quantidade_pagamentos

FROM empenho AS e
LEFT JOIN liquidacoes AS l
    ON e.id_empenho = l.id_empenho
LEFT JOIN pagamentos AS p
    ON e.id_empenho = p.id_empenho

WHERE COALESCE(p.valor_pago, 0)
    > COALESCE(l.valor_liquidado, 0)

ORDER BY
    diferenca_valor DESC;


-- =========================================================
-- PERGUNTA 5:
-- Existem empenhos com pagamentos registrados, mas sem
-- liquidações correspondentes?
--
-- Objetivo:
-- Identificar empenhos presentes na tabela pagamento
-- que não possuem nenhuma liquidação associada.
--
-- Melhorias:
-- - Quantidade de pagamentos;
-- - Valor total pago;
-- - Primeira e última data de pagamento.
--
-- Atenção:
-- A consulta identifica ausência de correspondência
-- na base disponível, não comprova uma falha de registro.
-- =========================================================

WITH pagamentos AS (
    SELECT
        id_empenho,
        COUNT(*) AS quantidade_pagamentos,
        SUM(valor) AS valor_pago,
        MIN(datapagamentoempenho) AS primeiro_pagamento,
        MAX(datapagamentoempenho) AS ultimo_pagamento
    FROM pagamento
    GROUP BY id_empenho
)
SELECT
    p.id_empenho,
    p.quantidade_pagamentos,
    p.valor_pago,
    p.primeiro_pagamento,
    p.ultimo_pagamento
FROM pagamentos AS p
LEFT JOIN liquidacao_nota_fiscal AS l
    ON p.id_empenho = l.id_empenho
WHERE l.id_empenho IS NULL
ORDER BY
    p.valor_pago DESC;


-- =========================================================
-- PERGUNTA 6 (NOVA):
-- Qual é o resumo financeiro por empenho?
--
-- Objetivo:
-- Produzir uma visão consolidada para conferência e para
-- uso posterior no Power BI.
--
-- Inclui empenhos sem pagamentos ou sem liquidações.
-- Não classifica automaticamente registros como irregulares.
-- =========================================================

WITH liquidacoes AS (
    SELECT
        id_empenho,
        SUM(valor) AS valor_liquidado,
        COUNT(*) AS quantidade_liquidacoes
    FROM liquidacao_nota_fiscal
    GROUP BY id_empenho
),
pagamentos AS (
    SELECT
        id_empenho,
        SUM(valor) AS valor_pago,
        COUNT(*) AS quantidade_pagamentos
    FROM pagamento
    GROUP BY id_empenho
)
SELECT
    e.id_empenho,
    e.valor AS valor_empenhado,

    COALESCE(l.valor_liquidado, 0)
        AS valor_liquidado,

    COALESCE(p.valor_pago, 0)
        AS valor_pago,

    COALESCE(l.valor_liquidado, 0) - e.valor
        AS diferenca_empenhado_liquidado,

    COALESCE(p.valor_pago, 0)
        - COALESCE(l.valor_liquidado, 0)
        AS diferenca_liquidado_pago,

    COALESCE(l.quantidade_liquidacoes, 0)
        AS quantidade_liquidacoes,

    COALESCE(p.quantidade_pagamentos, 0)
        AS quantidade_pagamentos

FROM empenho AS e
LEFT JOIN liquidacoes AS l
    ON e.id_empenho = l.id_empenho
LEFT JOIN pagamentos AS p
    ON e.id_empenho = p.id_empenho
ORDER BY
    e.id_empenho;
