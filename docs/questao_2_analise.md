# Questão 2 – Investigação de Anomalias e Análise Exploratória

Nesta etapa, foi realizada uma análise exploratória dos dados com o objetivo de identificar possíveis inconsistências no fluxo da despesa pública, considerando as etapas de empenho, liquidação e pagamento.

As análises foram guiadas por regras básicas do processo de execução da despesa pública e não têm como objetivo afirmar a existência de fraude, mas sim levantar possíveis pontos de atenção nos dados.

# Pagamentos sem empenho correspondente

Foi analisado se existiam pagamentos registrados sem um empenho correspondente, o que não é permitido no fluxo regular da despesa pública.

A consulta não retornou registros, indicando que todos os pagamentos possuem um empenho associado.

# Liquidações sem empenho correspondente

Também foi verificado se existiam liquidações sem empenho associado.

A análise não retornou resultados, mostrando que todas as liquidações presentes na base possuem empenho correspondente.

# Liquidações acima do valor empenhado

Foi realizada uma análise para verificar se o valor total liquidado ultrapassa o valor originalmente empenhado.

A consulta identificou diversos casos em que a soma das liquidações é maior que o valor empenhado. Esses registros indicam possíveis inconsistências nos dados ou a necessidade de análises complementares, como a existência de empenhos adicionais não representados na base.

# Pagamentos acima do valor liquidado

Também foi analisado se o valor total pago era maior que o valor liquidado, o que não é permitido no fluxo da despesa pública.

A consulta não retornou resultados, indicando que os pagamentos respeitam os valores liquidados.

# Pagamentos sem liquidação registrada

Por fim, foi investigada a existência de pagamentos registrados sem a respectiva liquidação.

Foram identificados alguns empenhos com pagamento registrado, mas sem liquidação associada. Esses casos podem indicar falhas de registro ou inconsistências na base de dados utilizada para o desafio.

# Considerações finais

De forma geral, os dados apresentam consistência em grande parte do fluxo da despesa pública. No entanto, algumas inconsistências foram identificadas, principalmente na relação entre empenhos e liquidações, o que reforça a importância de análises exploratórias para apoiar auditorias e tomadas de decisão.
