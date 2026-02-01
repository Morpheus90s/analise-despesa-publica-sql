# Fluxo da Despesa Pública

A despesa pública é o processo pelo qual o governo utiliza o dinheiro do orçamento para pagar serviços, compras ou obras.

De forma geral, a execução da despesa acontece em três etapas: empenho, liquidação e pagamento. Essas etapas são usadas como base para as análises deste projeto.

# Empenho

O empenho é a etapa em que o governo separa o valor que será pago no futuro.

Nessa fase, o pagamento ainda não aconteceu, apenas existe o compromisso de pagar um fornecedor ou contrato.

Nos dados, o empenho indica:
- quem é o fornecedor
- o valor reservado
- a data
- a entidade pública
- o contrato relacionado


# Liquidação

A liquidação ocorre quando o governo confirma que o serviço foi realizado ou que o produto foi entregue.

Essa etapa normalmente está ligada à emissão e conferência de notas fiscais.

Nos dados, a liquidação está associada às notas fiscais e sempre relacionada a um empenho.


# Pagamento

O pagamento é a última etapa, quando o valor é efetivamente pago ao fornecedor.

Para que exista um pagamento correto, é esperado que ele esteja ligado a um empenho já liquidado.

# Relação entre as etapas

O fluxo esperado da despesa pública é:

Empenho → Liquidação → Pagamento

Com base nesse fluxo, o projeto analisa se existem registros fora desse padrão, como pagamentos sem empenho ou valores pagos acima do valor empenhado.
