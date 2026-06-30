/*
===============================================================================
PROJETO: Análise de Orçamento de Despesas
DESCRIÇÃO:
Consulta responsável pela extração da base de orçamento de despesas utilizada
na construção do dashboard financeiro em Power BI.

OBJETIVO:
Consolidar os valores orçados de despesas para o exercício de 2026, realizando
o enriquecimento dos dados com informações da empresa, aplicando regras de
qualidade e padronizando os valores para análises posteriores.

REGRAS DE NEGÓCIO
-------------------------------------------------------------------------------
• Extrai apenas registros referentes ao ano de 2026.
• Relaciona cada filial à sua respectiva empresa através da dimensão de filiais.
• Considera apenas registros com valor orçado válido.
• Exclui valores nulos ou iguais a zero.
• Filtra somente os centros de custo de interesse para a análise.
• Padroniza os valores orçados utilizando COALESCE, ROUND e CAST para BIGINT.
• Garante a unicidade dos registros por meio do GROUP BY.

TRANSFORMAÇÕES
-------------------------------------------------------------------------------
1. LEFT JOIN com a dimensão de filiais para obtenção do id da empresa.
2. Tratamento de valores nulos utilizando COALESCE().
3. Arredondamento dos valores com ROUND().
4. Conversão do orçamento para BIGINT através de CAST().
5. Aplicação dos filtros de qualidade dos dados.
6. Remoção de possíveis duplicidades utilizando GROUP BY.

TABELAS UTILIZADAS
-------------------------------------------------------------------------------
• gold.financeiro.f_dre_orcamento_despesa
      Base fato contendo os valores orçados das despesas.

• gold.venda.dim_filial
      Dimensão responsável pelo relacionamento entre filial e empresa.

RESULTADO
-------------------------------------------------------------------------------
A consulta retorna uma base tratada contendo competência, empresa, filial,
centro de custo, plano de contas, fornecedor e valor orçado, pronta para
consumo em processos analíticos e dashboards financeiros.
===============================================================================
*/

SELECT * 
FROM (
    SELECT   
        desp.nu_competencia,
        desp.id_filial,
        filial.id_empresa,
        desp.id_tipo_conta,
        desp.id_conta AS id_agente_cobrador,
        desp.id_centro_custo,
        desp.id_plano_conta,
        desp.id_fornecedor,
CAST(ROUND(COALESCE(desp.vl_orcado,0),0) AS BIGINT) AS vl_orcado
    FROM gold.financeiro.f_dre_orcamento_despesa AS desp
    LEFT JOIN gold.venda.dim_filial AS filial 
        ON desp.id_filial = filial.id
    WHERE 
        desp.nu_competencia IN ('202603','202602','202601','202604','202605','202606','202607','202608','202609','202610','202611','202612' )
        AND desp.vl_orcado IS NOT NULL
        AND desp.vl_orcado <> 0
        AND desp.id_centro_custo IN (2439609, 2441603, 237980)

    GROUP BY
        desp.nu_competencia,
        desp.id_filial,
        filial.id_empresa,
        desp.id_tipo_conta,
        desp.id_conta,
        desp.id_centro_custo,
        desp.id_plano_conta,
        desp.id_fornecedor,
        desp.vl_orcado
)
 
