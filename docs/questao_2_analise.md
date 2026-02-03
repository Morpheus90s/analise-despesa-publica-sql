# Questão 2 – Investigação de Anomalias e Análise Exploratória

Nesta etapa, foi realizada uma análise exploratória dos dados com o objetivo de identificar possíveis inconsistências no fluxo da despesa pública, considerando as etapas de empenho, liquidação e pagamento.

As análises foram guiadas pelas regras básicas do processo de execução da despesa pública e têm como objetivo levantar pontos de atenção nos dados. Os resultados apresentados não têm o objetivo de afirmar a existência de fraude, mas sim de indicar situações que podem demandar análises complementares.

# Pagamentos sem empenho correspondente

**Pergunta:**  
Existem pagamentos registrados sem um empenho correspondente?

**Resultado:**  
A consulta não retornou registros.

**Interpretação:**  
O resultado indica que todos os pagamentos presentes na base possuem um empenho associado, o que está de acordo com o fluxo regular da despesa pública.

# Liquidações sem empenho correspondente

**Pergunta:**  
Existem liquidações sem empenho associado?

**Resultado:**  
A análise não retornou registros.

**Interpretação:**  
Todas as liquidações presentes na base estão corretamente associadas a um empenho, indicando consistência nessa etapa do fluxo.

# Liquidações acima do valor empenhado

**Pergunta:**  
O valor total liquidado ultrapassa o valor originalmente empenhado?

**Resultado:**  
Foram identificados diversos casos em que a soma das liquidações é superior ao valor empenhado.

**Interpretação:**  
Esses registros indicam possíveis inconsistências nos dados ou a necessidade de análises adicionais, como a existência de empenhos complementares não representados na base utilizada no desafio.

# Pagamentos acima do valor liquidado

**Pergunta:**  
O valor total pago é maior que o valor liquidado?

**Resultado:**  
A consulta não retornou registros.

**Interpretação:**  
Os pagamentos respeitam os valores liquidados, o que indica conformidade nessa etapa do fluxo.

# Pagamentos sem liquidação registrada

**Pergunta:**  
Existem pagamentos registrados sem liquidação associada?

**Resultado:**  
Foram identificados alguns empenhos com pagamento registrado, mas sem liquidação correspondente.

**Interpretação:**  
Esses casos podem indicar falhas de registro, defasagens entre os sistemas ou inconsistências na base de dados utilizada para a análise.

# Considerações finais

De forma geral, os dados apresentam consistência na maior parte do fluxo da despesa pública. No entanto, algumas inconsistências foram identificadas, especialmente na relação entre empenhos e liquidações.

Esses achados reforçam a importância de análises exploratórias para apoiar processos de auditoria, monitoramento de gastos públicos e tomada de decisão baseada em dados.
