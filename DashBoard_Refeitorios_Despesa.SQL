SELECT 
  DATE_FORMAT(TO_DATE(CAST(OC.nu_competencia AS STRING) || '01', 'yyyyMMdd'), 'MM/yyyy') AS DATA,
  UPPER(OC.id_empresa) as EMPRESA,
  OC.id_plano_conta as id_Plano,
  OC.ID_FILIAL as id_FILIAL,
  UPPER(CONCAT(OC.id_filial, ' - ', fl.descricao)) as FILIAL,
  UPPER(CONCAT(OC.id_plano_conta, ' ', pc.cs_plano_conta, ' ', pc.nm_plano_conta)) as PLANO,
  UPPER(OC.id_centro_custo) as ID_CENTRO,
  UPPER(CC.cs_centro) as SETOR,
  UPPER(concat(OC.id_fornecedor, ' - ', f.descricao)) as FORNECEDOR,
CAST(SUM(OC.vl_pago) AS BIGINT) as PAGO,
CAST(SUM(OC.vl_aberto) AS BIGINT) AS ABERTO
FROM gold.financeiro.f_dre_acompanhamento_despesa AS OC
INNER JOIN gold.venda.dim_filial AS fl ON OC.id_filial = fl.id
INNER JOIN gold.financeiro.dim_centro_custos AS CC ON CC.ID = OC.id_centro_custo 
INNER JOIN gold.financeiro.dim_plano_contas AS PC ON OC.id_plano_conta = PC.id
LEFT JOIN gold.venda.dim_fornecedor AS f ON OC.id_fornecedor = f.id
WHERE 
-- Data mínima: 01/01 do ano atual - 2 (ex: 2024)
    TO_DATE(CAST(oc.nu_competencia AS STRING) || '01', 'yyyyMMdd') >=
        DATE_TRUNC('year', CURRENT_DATE) - INTERVAL 2 YEAR

    -- Data máxima: último dia do mês atual (ex: 2026 até mês atual)
    AND TO_DATE(CAST(oc.nu_competencia AS STRING) || '01', 'yyyyMMdd') <=
        DATE_TRUNC('month', CURRENT_DATE) + INTERVAL 1 MONTH - INTERVAL 1 DAY

AND CC.cs_centro NOT LIKE '1.1.2%' 
AND OC.id_centro_custo IN (2439609, 2441603, 237980)
--AND oc.id_filial not IN (194, 257, 37, 51, 608, 253)
--and oc.id_plano_contas IN (102233)
--AND ID_empresa = IN (2, 15, 501)
GROUP BY 
  DATE_FORMAT(TO_DATE(CAST(OC.nu_competencia AS STRING) || '01', 'yyyyMMdd'), 'MM/yyyy'),
  id_filial,
  id_plano_conta,
  UPPER(OC.id_empresa),
  UPPER(CONCAT(OC.id_filial, ' - ', fl.descricao)),
  UPPER(CONCAT(OC.id_plano_conta, ' ', pc.cs_plano_conta, ' ', pc.nm_plano_conta)),
  UPPER(OC.id_centro_custo),
  UPPER(CC.cs_centro),
  UPPER(concat(OC.id_fornecedor, ' - ', f.descricao)),
  fl.id_codigo_central
 
