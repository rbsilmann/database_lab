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


-- https://github.com/jfcoz/postgresqltuner

-- sudo sysctl -w vm.overcommit_ratio=90
-- sudo sysctl -w vm.overcommit_memory=2

-- Persistência:
-- echo "vm.overcommit_ratio=90" | sudo tee -a /etc/sysctl.conf
-- echo "vm.overcommit_memory=2" | sudo tee -a /etc/sysctl.conf
