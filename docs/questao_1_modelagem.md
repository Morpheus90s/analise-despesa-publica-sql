# Modelagem de Dados

A modelagem de dados foi construída a partir do fluxo da despesa pública, considerando as etapas de empenho, liquidação e pagamento.

O empenho foi definido como a entidade central do modelo, pois representa o início da despesa pública e está diretamente relacionado às etapas seguintes.

As tabelas de liquidação e pagamento foram associadas ao empenho por meio do identificador do empenho, estabelecendo relacionamentos do tipo um para muitos (1:N), porque que um empenho pode possuir múltiplas liquidações e múltiplos pagamentos ao longo do tempo.

Não foram criadas tabelas auxiliares neste modelo. O foco foi representar o fluxo principal da despesa pública, e informações como entidade, contrato e credor foram mantidas como atributos da tabela de empenho, sendo suficientes para as análises propostas.

# Regras de Negócio

- O valor do empenho deve ser maior ou igual à soma dos valores liquidados.
- O valor liquidado deve ser maior ou igual à soma dos pagamentos realizados.

Essas regras representam o comportamento esperado do processo de execução da despesa pública, mas não foram implementadas como restrições no banco de dados.
