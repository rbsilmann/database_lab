-- Tipos de Dados
-- Booleanos, caracteres, numéricos, temporais, arrays, json e UUID
-- Booleano:
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ativo BOOLEAN NOT NULL
);
INSERT INTO usuarios (nome, ativo)
VALUES ('João', TRUE),
    ('Maria', FALSE);
-- Caracteres:
CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);
INSERT INTO produtos (nome, descricao)
VALUES ('Teclado', 'Teclado mecânico RGB'),
    ('Mouse', NULL);
-- Numéricos:
CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    quantidade INTEGER CHECK (quantidade > 0),
    preco_unitario DECIMAL(10, 2)
);
INSERT INTO vendas (quantidade, preco_unitario)
VALUES (2, 49.99),
    (5, 99.90);
-- Temporais:
CREATE TABLE eventos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    data_evento DATE NOT NULL,
    duracao INTERVAL
);
INSERT INTO eventos (nome, data_evento, duracao)
VALUES ('Workshop PostgreSQL', '2024-12-10', '2 hours'),
    ('Hackathon', '2024-12-12', '3 days');
-- Arrays:
CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    notas NUMERIC [] NOT NULL
);
INSERT INTO alunos (nome, notas)
VALUES ('Pedro', ARRAY [7.5, 8.0, 9.0]),
    ('Ana', ARRAY [9.0, 10.0]);
-- JSON e JSONB:
CREATE TABLE configuracoes (
    id SERIAL PRIMARY KEY,
    parametros JSONB NOT NULL
);
INSERT INTO configuracoes (parametros)
VALUES ('{"theme": "dark", "notifications": true}'),
    ('{"theme": "light", "notifications": false}');
-- UUID:
CREATE TABLE sessao (
    id UUID DEFAULT gen_random_uuid(),
    usuario_id INTEGER NOT NULL
);
INSERT INTO sessao (usuario_id)
VALUES (1),
    (2);
-- Tabelas temporárias e tabelas de backup:
CREATE TEMP TABLE temp_vendas_2023 AS
SELECT *
FROM public.venda
WHERE data BETWEEN '2023-01-01' AND '2023-12-31';
CREATE TABLE vendas_2024 AS
SELECT *
FROM public.venda WITH NO DATA;
-- Diferencia-se do SELECT INTO por isso.
-- Sequences e tipo SERIAL:
CREATE TABLE categorias (id SERIAL PRIMARY KEY, nome VARCHAR(50));
INSERT INTO categorias (nome)
VALUES ('Eletrônicos'),
    ('Móveis');
-- Exemplo manual:
CREATE SEQUENCE categoria_id_seq START 1 INCREMENT 1;
CREATE TABLE categorias2 (
    id INTEGER DEFAULT nextval('categoria_id_seq'),
    nome VARCHAR(50)
);
INSERT INTO categorias2 (nome)
VALUES ('Livros'),
    ('Eletrodomésticos');
-- Alterando estruturas:
ALTER TABLE clientes
ADD COLUMN telefone VARCHAR(20);
-- Adicionando dados com a nova coluna:
INSERT INTO clientes (id, nome, telefone)
VALUES (1, 'Carlos', '11999998888');
-- Removendo colunas:
ALTER TABLE clientes DROP COLUMN telefone;
-- Renomeando colunas:
ALTER TABLE clientes
    RENAME COLUMN nome TO nome_completo;
