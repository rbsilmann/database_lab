-- Criar a tabela vendas
CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    id_produto INT,
    valor DECIMAL(10, 2),
    data_venda DATE
);

-- Gerar registros aleatórios
INSERT INTO vendas (id_produto, valor, data_venda)
SELECT
    (RANDOM() * 100)::INT,
    (RANDOM() * 1000)::DECIMAL(10, 2),
    CURRENT_DATE - (RANDOM() * 365)::INT
FROM generate_series(1, 1000000);


-- Exibir o planejamento e o tempo de execução
EXPLAIN ANALYZE SELECT * FROM vendas WHERE id_produto = 50;

-- Criar o índice
CREATE INDEX idx_vendas_id_produto ON vendas(id_produto);
-- DROP INDEX idx_vendas_id_produto;

-- Realizar a atualização de estatísticas manual
ANALYZE vendas;

-- Exibir o novo planejamento e o novo tempo de execução
EXPLAIN ANALYZE SELECT * FROM vendas WHERE id_produto = 50;

-- pgbench
-- Com o banco criado, inicialize as tabelas do utilitário
-- pgbench -i -s 10 -U postgres [nome do banco]
-- Primeiro teste com 10 conexões, 2 threads e 30 segundos
-- pgbench -c 10 -j 2 -T 30 -U postgres [nome do banco]
-- Segundo teste com os mesmos parâmetros mas usando uma consulta nossa
-- pgbench -c 10 -j 2 -T 30 -f ./SQL/09-test.sql -U postgres [nome do banco]

-- https://github.com/jfcoz/postgresqltuner

-- sudo sysctl -w vm.overcommit_ratio=90
-- sudo sysctl -w vm.overcommit_memory=2

-- Persistência:
-- echo "vm.overcommit_ratio=90" | sudo tee -a /etc/sysctl.conf
-- echo "vm.overcommit_memory=2" | sudo tee -a /etc/sysctl.conf

-- https://github.com/darold/pgbadger

-- sudo apt -y install pgbadger
-- sudo yum -y install pgbadger

-- Configuração:
-- https://github.com/rbsilmann/pg-badger

-- select name, setting, boot_val, context from pg_settings where setting <> boot_val;

-- Seq Scan (Sequential Scan):
-- Leitura sequencial de todas as linhas da tabela.
-- Ideal para tabelas pequenas ou consultas que precisam de muitos dados.

-- Index Scan:
-- Utilize um índice para encontrar as linhas necessárias.
-- Mais eficiente que o Seq Scan quando a consulta retorna poucas linhas.

-- Bitmap Index Scan:
-- Usado para consultas que retornam muitas linhas, combina o uso de índices e operações em memória.

-- Hash Join vs. Nested Loop:
-- Hash Join:
-- Criado para unir tabelas grandes com base em uma chave.
-- Nested Loop:
-- Iteração para cada linha da tabela externa, buscando correspondência na interna. Funciona bem para tabelas pequenas.

-- Aggregation:
-- GroupAggregate:
-- Utilizado para agrupamentos simples.
-- HashAggregate:
-- Usa tabelas hash para acelerar agregações em grandes conjuntos de dados.
