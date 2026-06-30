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
 
