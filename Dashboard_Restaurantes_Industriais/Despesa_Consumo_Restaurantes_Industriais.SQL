/*
===============================================================================
PROJETO: Análise de Despesas com Matéria-Prima
DESCRIÇÃO:
Consulta responsável pela extração da base de consumo de matéria-prima utilizada
na construção do dashboard financeiro em Power BI.

OBJETIVO:
Extrair as vendas dos produtos utilizados como matéria-prima do setor de
Restaurante, permitindo acompanhar o volume consumido e o valor movimentado por
filial ao longo do tempo.

REGRAS DE NEGÓCIO
-------------------------------------------------------------------------------
• Considera apenas vendas realizadas a partir de dezembro de 2024.
• Analisa exclusivamente produtos pertencentes ao departamento
  "RESTAURANTE".
• Restringe a consulta aos produtos definidos como matéria-prima para a
  análise.
• Relaciona as informações de produto e filial para enriquecer os registros.
• Padroniza os valores numéricos através de arredondamento e conversão para
  BIGINT.

TRANSFORMAÇÕES
-------------------------------------------------------------------------------
1. Conversão da data da venda para o formato MM/AAAA.
2. Enriquecimento da base com informações de filial e produto.
3. Seleção apenas dos produtos classificados como matéria-prima.
4. Arredondamento das quantidades comercializadas.
5. Arredondamento dos valores de venda.
6. Conversão das métricas numéricas para BIGINT.

TABELAS UTILIZADAS
-------------------------------------------------------------------------------
• gold.venda.f_vcl_verba_imposto
      Base fato contendo as movimentações de vendas.

• gold.masterdata.produto
      Dimensão utilizada para identificar departamento e descrição dos
      produtos.

• gold.masterdata.filial
      Dimensão responsável pelas informações cadastrais das filiais.

RESULTADO
-------------------------------------------------------------------------------
A consulta retorna uma base contendo filial, período da venda, setor,
produto, quantidade comercializada e valor total das vendas, servindo como
fonte para análises de consumo e acompanhamento dos custos de matéria-prima
no dashboards financeiro de restaurante industrial.
===============================================================================
*/

SELECT
  v.id_filial AS FILIAL,
  DATE_FORMAT(v.dt_venda, 'MM/yyyy') AS data_venda,
  f.nome as nome_filial,
  p.nm_departamento as SETOR,
  p.descricao AS PRODUTO,
  v.id_produto AS PRODUTO_ID,
CAST(ROUND(v.qt_venda,0) AS BIGINT) AS QUANTIDADE,
CAST(ROUND(v.vl_venda_total,0) AS BIGINT) AS VENDA
 
 
FROM gold.venda.f_vcl_verba_imposto v
JOIN GOLD.masterdata.produto p
  ON v.id_produto = p.id
JOIN gold.masterdata.filial f
  ON v.id_filial = f.id
 
 
WHERE v.dt_venda >= '2024-12-01'
  AND p.nm_departamento = 'RESTAURANTE'
AND v.id_produto IN (236808, 229209)
