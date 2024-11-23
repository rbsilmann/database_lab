-- SELECT v.id_produto, 
-- v.quantidade, 
-- v.precovenda, 
-- v.valortotal, 
--        	v.valordesconto + v.valordescontocupom AS valordesconto, 
--        	p.descricaocompleta AS produto, v.unidademedida, p.id_tipoembalagem
-- FROM pdv.vendaitem AS v
-- INNER JOIN produto AS p ON p.id = v.id_produto
-- WHERE v.id_venda = (RANDOM() * 100)::INT
-- ORDER BY v.sequencia;

SELECT v.id_produto, 
v.quantidade, 
v.precovenda, 
v.valortotal, 
       	v.valordesconto + v.valordescontocupom AS valordesconto, 
       	p.descricaocompleta AS produto, v.unidademedida, p.id_tipoembalagem
FROM pdv.vendaitem AS v
INNER JOIN produto AS p ON p.id = v.id_produto
WHERE v.id_venda = 1000
ORDER BY v.sequencia;