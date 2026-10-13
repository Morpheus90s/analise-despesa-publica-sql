# Análise de Despesas Públicas com SQL e PostgreSQL

Projeto de análise de dados voltado ao estudo da execução da despesa pública, com foco em **modelagem relacional, consultas SQL, investigação de inconsistências e análise temporal**.

O trabalho foi desenvolvido a partir de um desafio técnico de Dados & Analytics e posteriormente ampliado com uma base sintética em PostgreSQL para testar consultas e validar cenários de inconsistência.

## Objetivos do projeto

- Compreender o fluxo da despesa pública e as relações entre empenhos, liquidações e pagamentos.
- Estruturar os dados em um modelo relacional adequado às análises.
- Utilizar SQL para explorar os dados e investigar possíveis inconsistências.
- Analisar valores e comportamento temporal das despesas.
- Documentar a metodologia, as consultas e os resultados de forma reproduzível.

## Competências demonstradas

- **SQL e PostgreSQL:** consultas analíticas, agregações, subconsultas e CTEs.
- **Modelagem de dados:** representação das relações entre entidades e etapas da despesa pública.
- **Qualidade e consistência dos dados:** identificação de registros sem correspondência e comparação de valores entre etapas.
- **Análise temporal:** agregação de valores por mês e ano.
- **Visualização de dados:** representação gráfica e comunicação de resultados.
- **Documentação técnica:** organização de consultas, explicações e relatório final.

## Contexto do problema

A execução da despesa pública envolve três etapas fundamentais:

1. **Empenho:** reserva de recursos orçamentários para uma despesa.
2. **Liquidação:** verificação do direito do credor a receber, conforme a entrega do bem ou a prestação do serviço.
3. **Pagamento:** quitação da obrigação financeira.

A análise dessas etapas permite investigar como os valores se relacionam ao longo do processo e identificar registros que merecem verificação.

## Desenvolvimento

### 1. Modelagem de dados

Foi elaborado um modelo relacional para representar as informações envolvidas na execução da despesa pública e apoiar as consultas analíticas.

- [Diagrama do modelo de dados](modelagem/modelo_dados.png)
- [Descrição da modelagem](docs/questao_1_modelagem.md)
- [Arquivo complementar do modelo](modelagem/diagrama.md)

### 2. Análise exploratória e investigação de inconsistências

Foram desenvolvidas consultas SQL para investigar situações como:

- Pagamentos sem empenho correspondente.
- Liquidações sem empenho correspondente.
- Valores liquidados superiores ao valor empenhado.
- Valores pagos superiores aos valores liquidados.
- Empenhos com pagamentos registrados, mas sem liquidações correspondentes.
- Consolidação dos valores por empenho para apoiar a análise.

As consultas foram organizadas para facilitar a inspeção dos registros e a investigação de possíveis problemas de consistência.

- [Consultas SQL de investigação](sql/questao_2_anomalias.sql)
- [Análise e conclusões documentadas](docs/questao_2_analise.md)

### 3. Análise temporal

Foram desenvolvidas consultas para explorar a distribuição temporal dos registros, incluindo:

- Intervalos de datas disponíveis em cada etapa.
- Valores agregados mensalmente para empenhos, liquidações e pagamentos.
- Consolidações anuais por etapa.
- Distribuição dos valores empenhados por entidade.

- [Consultas de análise temporal](sql/questao_4_historico_temporal.sql)
- [Consultas de exploração inicial](sql/exploracao_inicial.sql)

### 4. Visualização de dados

O projeto também inclui uma visualização comparativa dos valores empenhados e liquidados, acompanhada da documentação sobre as visualizações desenvolvidas no desafio.

- [Visualização: empenhado versus liquidado](visualizacoes/comparacao_empenhado_liquidado.png)
- [Descrição das visualizações](docs/questao_3_visualizacoes.md)

### 5. Testes e validação das consultas

Para permitir a execução e a verificação das consultas sem depender da base original do desafio, foi criada uma base sintética em PostgreSQL.

Os registros de teste incluem cenários controlados de inconsistência, como pagamentos e liquidações sem empenho correspondente. Esses casos permitem verificar se as consultas identificam as situações previstas.

- [Script de criação da base de teste](sql/00_base_teste.sql)
- [Script de testes e validação](sql/01_testes_validacao.sql)

**Importante:** os dados dessa base são sintéticos e têm finalidade de teste. Eles não representam despesas públicas reais nem devem ser interpretados como resultados da análise original.

## Tecnologias e ferramentas

| Tecnologia ou ferramenta | Aplicação no projeto |
|---|---|
| SQL | Consultas, agregações e investigação de inconsistências |
| PostgreSQL | Armazenamento e execução das consultas |
| Docker | Ambiente isolado para execução do banco de teste |
| Git e GitHub | Versionamento e organização do projeto |
| Power BI | Visualização de dados no contexto do desafio |
| DBeaver | Consulta e exportação de dados, conforme a abordagem documentada |

## Como executar os testes

Os passos abaixo pressupõem que o Docker esteja instalado e que os comandos sejam executados na raiz do repositório.

**1. Inicie um banco PostgreSQL de teste**

```bash
docker run --name postgres-despesas \
  -e POSTGRES_PASSWORD=teste123 \
  -e POSTGRES_DB=despesas \
  -p 5432:5432 \
  -d postgres:16
```

**2. Execute o script de criação da base sintética**

```bash
PGPASSWORD=teste123 psql \
  -h localhost -U postgres -d despesas \
  -f sql/00_base_teste.sql
```

**3. Execute os testes de validação**

```bash
PGPASSWORD=teste123 psql \
  -h localhost -U postgres -d despesas \
  -f sql/01_testes_validacao.sql
```

**4. Execute as consultas analíticas**

Por exemplo, para investigar inconsistências:

```bash
PGPASSWORD=teste123 psql \
  -h localhost -U postgres -d despesas \
  -f sql/questao_2_anomalias.sql
```

Para executar a análise temporal:

```bash
PGPASSWORD=teste123 psql \
  -h localhost -U postgres -d despesas \
  -f sql/questao_4_historico_temporal.sql
```

> **Atenção:** o script de criação da base de teste recria as tabelas. Utilize-o somente no banco destinado aos testes, pois ele pode remover estruturas e dados existentes.

## Documentação complementar

- [Fluxo da despesa pública](docs/fluxo_despesa_publica.md)
- [Relatório técnico final](relatorio_final.pdf)

## Limitações e escopo

A base sintética foi criada para possibilitar testes controlados das consultas. Os resultados obtidos com ela servem para verificar o comportamento do código nos cenários preparados, mas não substituem a validação dos resultados sobre a base original do desafio.

O repositório contém a visualização exportada em imagem e a documentação correspondente. O arquivo editável do dashboard Power BI não está incluído nesta versão.

---

**Autor:** [Morpheus90s](https://github.com/Morpheus90s)