-- Pergunta 1:
-- Existem pagamentos sem empenho correspondente?
-- Resultado: Nenhum registro encontrado.
-- Interpretação: Todos os pagamentos possuem empenho associado.

SELECT 
  p.id_pagamento,
  p.id_empenho,
  p.valor,
  p.datapagamentoempenho
FROM pagamento p
LEFT JOIN empenho e
  ON p.id_empenho = e.id_empenho
WHERE e.id_empenho IS NULL;

-- Pergunta 2:
-- Existem liquidações sem empenho correspondente?
-- Resultado: Nenhum registro encontrado.
-- Interpretação: Todas as liquidações possuem empenho associado.

SELECT
  l.id_liquidacao_empenhonotafiscal,
  l.id_empenho,
  l.valor,
  l.data_emissao
FROM liquidacao_nota_fiscal l
LEFT JOIN empenho e
  ON l.id_empenho = e.id_empenho
WHERE e.id_empenho IS NULL;

-- Pergunta 3:
-- O valor total liquidado é maior que o valor empenhado?
-- Resultado: Foram encontrados casos em que a soma das liquidações supera o valor empenhado.
-- Interpretação: Esses registros podem indicar inconsistência nos dados ou a necessidade
-- de análise complementar do processo de empenho.

SELECT
  e.id_empenho,
  e.valor AS valor_empenhado,
  SUM(l.valor) AS valor_liquidado
FROM empenho e
JOIN liquidacao_nota_fiscal l
  ON e.id_empenho = l.id_empenho
GROUP BY e.id_empenho, e.valor
HAVING SUM(l.valor) > e.valor;

-- Pergunta 4:
-- O valor pago é maior que o valor liquidado?
-- Resultado: Nenhum registro encontrado.
-- Interpretação: Os pagamentos respeitam o valor liquidado, indicando consistência
-- no fluxo de liquidação e pagamento.

SELECT
  e.id_empenho,
  SUM(l.valor) AS valor_liquidado,
  SUM(p.valor) AS valor_pago
FROM empenho e
JOIN liquidacao_nota_fiscal l
  ON e.id_empenho = l.id_empenho
JOIN pagamento p
  ON e.id_empenho = p.id_empenho
GROUP BY e.id_empenho
HAVING SUM(p.valor) > SUM(l.valor);

-- Pergunta 5:
-- Existem empenhos com pagamento registrado, mas sem liquidação?
-- Resultado: Foram encontrados empenhos com pagamento sem liquidação associada.
-- Interpretação: Esses casos podem indicar falha de registro ou inconsistência
-- no fluxo da despesa pública.

SELECT DISTINCT
  p.id_empenho
FROM pagamento p
LEFT JOIN liquidacao_nota_fiscal l
  ON p.id_empenho = l.id_empenho
WHERE l.id_empenho IS NULL;
