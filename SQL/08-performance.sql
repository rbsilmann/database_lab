-- Exemplo public.venda

-- Essa consulta é relativamente rápida, pois estamos limitando o
-- número de registros retornados.
SELECT * FROM venda LIMIT 1000;

-- Essa consulta, por outro lado, pode ser lenta, especialmente se a 
-- tabela for grande. O PostgreSQL precisa varrer toda a tabela para 
-- encontrar os registros que satisfazem a condição valortotal > 200.
SELECT * FROM venda WHERE valortotal > 200;

-- Vamos observar o planejamento e a execução dessa consulta.
EXPLAIN ANALYZE SELECT * FROM venda WHERE valortotal > 200;

-- Analogia da Biblioteca
CREATE INDEX idx1_venda ON venda (valortotal);

ANALYZE venda;

EXPLAIN ANALYZE SELECT * FROM venda WHERE valortotal > 200;

-- Sem um índice, o banco de dados teria que varrer toda a tabela venda 
-- para encontrar os registros que atendem ao critério valortotal > 200.
-- Com índices o banco de dados pode localizar rapidamente 
-- os registros correspondentes, sem precisar varrer toda a tabela.
-- Na prática ele localiza as páginas onde os registros completos estão e
-- ignora as que não atendem aos critérios.

-- Quando criar um índice?
-- 1. Colunas frequentemente usadas em cláusulas WHERE;
-- 2. Colunas utilizadas em ORDER BY;
-- 3. Colunas utilizadas em GROUP BY;
-- 4. Colunas utilizadas em joins;

-- Dicas:
-- 1. Evitar o excesso de índices: Muitos índices podem prejudicar o desempenho 
-- de inserções, atualizações e deleções;
-- 2. Monitorar o desempenho: Utilize ferramentas como EXPLAIN ANALYZE para 
-- verificar se os índices estão sendo utilizados corretamente.
-- 3. Ajustar os índices conforme necessário: À medida que sua base de dados evolui, 
-- você pode precisar ajustar os índices.

SELECT	i.relname "Nome da Tabela",
		i.schemaname "Nome do Schema",
		indexrelname "Nome do Indice",
 		pg_size_pretty(pg_total_relation_size(relid)) As "Tamanho Total",
 		pg_size_pretty(pg_indexes_size(relid)) as "Tamanho Total dos Indices",
 		pg_size_pretty(pg_relation_size(relid)) as "Tamanho da Tabela",
 		pg_size_pretty(pg_relation_size(indexrelid)) "Tamanho do Indice"
FROM pg_stat_all_indexes i JOIN pg_class c ON i.relid=c.oid 
WHERE i.relname='estoque';

CREATE INDEX IF NOT EXISTS idx1_estoque
    ON public.estoque (data) WHERE data > '2024-04-25';