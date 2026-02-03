# Desafio – Estágio em Dados & Analytics

Este repositório contém a resolução do desafio técnico para o processo seletivo de Estágio em Dados & Analytics.

O objetivo do desafio é estudar o fluxo de execução da despesa pública, estruturar os dados disponibilizados, realizar análises exploratórias e investigar possíveis inconsistências ou anomalias nos gastos públicos, além de comunicar os principais insights por meio de visualizações.

# Contexto do desafio

A execução da despesa pública segue um fluxo bem definido, composto principalmente pelas etapas de:

- **Empenho**
- **Liquidação**
- **Pagamento**

Com base nesse fluxo e nas bases de dados fornecidas (compras públicas e execução orçamentária), este projeto busca compreender a relação entre essas etapas e analisar o comportamento das despesas públicas.

# Abordagem adotada

O desenvolvimento do desafio foi organizado nas seguintes etapas:

1. **Entendimento do negócio**  
   Estudo do fluxo da despesa pública e das relações entre empenhos, liquidações e pagamentos, com base em materiais oficiais.

2. **Modelagem de dados**  
   Construção de um modelo relacional simples e consistente, alinhado com os dados fornecidos e com o objetivo analítico do desafio.

3. **Análise exploratória e investigação de anomalias**  
   Elaboração de questionamentos e consultas SQL para identificar possíveis inconsistências, falhas de registro ou padrões relevantes.

4. **Visualização de dados**  
   Criação de visualizações para comunicar os principais insights encontrados de forma clara e objetiva.

# Estrutura do repositório

##  Fluxo da Despesa Pública

Uma breve contextualização sobre o fluxo legal da despesa pública (empenho, liquidação e pagamento), utilizada como base conceitual para as análises, está disponível em:

- `docs/fluxo_despesa_publica.md`


## Questão 1 — Modelagem de Dados

- Diagrama relacional disponível em:  
  `modelagem/modelo_dados.png`
- Explicação da modelagem em:  
  `docs/questao_1_modelagem.md`

## Questão 2 — Análise Exploratória e Investigação de Anomalias

- Questionamentos, análises e conclusões documentados em:  
  `docs/questao_2_analise.md`
- Consultas SQL utilizadas disponíveis em:  
  `sql/questao_2_anomalias.sql`

## Questão 3 — Visualizações

As visualizações foram desenvolvidas no **Power BI**, utilizando dados extraídos do banco PostgreSQL via DBeaver e importados localmente em arquivos CSV.

- Arquivo do dashboard:  
  `visualizacoes/questao_3_visualizacao.pbix`
- Descrição das visualizações e insights em:  
  `docs/questao_3_visualizacao.md`

## Relatório Técnico Final

O relatório técnico consolidando o entendimento do negócio, a modelagem, as análises realizadas e os principais insights encontra-se em:

- `docs/relatorio_final.pdf`

## Observações técnicas

Devido a limitações de conexão direta do Power BI com o banco de dados remoto, os dados foram exportados via DBeaver e utilizados localmente para a construção das visualizações.