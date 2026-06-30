  SELECT
  v.id_filial AS FILIAL,
  DATE_FORMAT(v.dt_venda, 'MM/yyyy') AS data_venda,
  f.nome as nome_filial,
  p.nm_departamento as SETOR,
  p.descricao AS PRODUTO,
  v.id_produto AS PRODUTO_ID,
CAST(ROUND(v.qt_venda,0) AS BIGINT) AS QUANTIDADE,
CAST(ROUND(v.vl_venda_total,0) AS BIGINT) AS VENDA
 
 
from gold.venda.f_vcl_verba_imposto v
join GOLD.masterdata.produto p
  on v.id_produto = p.id
join gold.masterdata.filial f
  on v.id_filial = f.id
 
 
where v.dt_venda >= '2024-12-01'
  and p.nm_departamento = 'RESTAURANTE'
AND v.id_produto IN (236808, 229209)
