# Fluxo da Despesa Pública

A despesa pública é o processo pelo qual o governo utiliza os recursos previstos no orçamento para realizar pagamentos relacionados a serviços, compras ou obras.

De forma geral, a execução da despesa ocorre em três etapas principais: empenho, liquidação e pagamento. Essas etapas servem como base para as análises desenvolvidas neste projeto.

# Empenho

O empenho é a etapa em que o governo reserva um valor do orçamento para um pagamento futuro.

Nesse momento, o pagamento ainda não ocorreu; existe apenas o compromisso formal com um fornecedor ou contrato.

Nos dados analisados, o empenho contém informações como:
- fornecedor
- valor empenhado
- data do empenho
- entidade pública
- contrato relacionado

# Liquidação

A liquidação ocorre quando o governo confirma que o serviço foi prestado ou que o produto foi entregue conforme o contratado.

Essa etapa normalmente está associada à emissão e conferência de notas fiscais e deve estar sempre vinculada a um empenho.

# Pagamento

O pagamento é a etapa final da execução da despesa, quando o valor é efetivamente transferido ao fornecedor.

Para que o fluxo esteja correto, espera-se que todo pagamento esteja associado a um empenho previamente liquidado.

# Relação entre as etapas

O fluxo esperado da despesa pública é:

Empenho → Liquidação → Pagamento

Com base nesse fluxo, este projeto analisa a existência de registros fora do padrão esperado, como pagamentos sem empenho correspondente ou valores pagos acima do valor empenhado.
