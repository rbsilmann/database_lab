-- Appendix Errors Code
-- https://www.postgresql.org/docs/14/errcodes-appendix.html

-- Class XX — Internal Error
-- XX000	internal_error
-- XX001	data_corrupted
-- XX002	index_corrupted

-- PANIC: could not locate a valid checkpoint record
-- FATAL: the database system is in recovery mode

---------------------------------------------------------
-- Colunas inválidas
-- Cria a tabela com uma coluna de texto
CREATE TABLE tabela_com_problemas (
    id serial PRIMARY KEY,
    coluna_com_problema text
);

-- Insere uma linha com dados válidos
INSERT INTO tabela_com_problemas (coluna_com_problema) VALUES ('dados válidos');
INSERT INTO tabela_com_problemas (coluna_com_problema) VALUES ('dados válidos');
INSERT INTO tabela_com_problemas (coluna_com_problema) VALUES ('dados válidos');
INSERT INTO tabela_com_problemas (coluna_com_problema) VALUES ('dados válidos');

-- Insere uma linha com dados inválidos (exemplo: valor nulo ou vazio que pode causar erro)
INSERT INTO tabela_com_problemas (coluna_com_problema) VALUES (NULL);
INSERT INTO tabela_com_problemas (coluna_com_problema) VALUES (NULL);
INSERT INTO tabela_com_problemas (coluna_com_problema) VALUES (NULL);
INSERT INTO tabela_com_problemas (coluna_com_problema) VALUES (NULL);

DO $$
DECLARE 
    t tid;
    x text;
BEGIN
    -- Loop para percorrer todas as linhas da tabela 'tabela_com_problemas'
    FOR t IN SELECT ctid FROM tabela_com_problemas LOOP
    BEGIN
        SELECT coluna_com_problema INTO x FROM tabela_com_problemas WHERE ctid = t;
        -- Verifica se o valor é NULL para exemplificar nossos testes
        IF x IS NULL THEN
            RAISE NOTICE 'Linha com problema (NULL) - ctid = %', t;
        ELSE
            RAISE NOTICE 'Linha com valor - ctid = %, valor = %', t, x;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        -- Se ocorrer erro ao tentar acessar a linha, exibe o ctid
        RAISE NOTICE 'Erro ao acessar a linha com ctid = %', t;
    END;
    END LOOP;
END;$$;

-- Deletando a linha corrompida identificada pelo ctid
DELETE FROM tabela_com_problemas WHERE ctid = 'valor_do_ctid';

-- Atualizando o valor corrompido para um valor válido
UPDATE tabela_com_problemas SET coluna_com_problema = 'valor corrigido' WHERE ctid = 'valor_do_ctid';

-- Limpe o ambiente:
DROP TABLE tabela_com_problemas;

---------------------------------------------------------
-- Linhas inválidas:
-- Criando a tabela para armazenar dados de clientes
CREATE TABLE tabela_com_problemas (
    id SERIAL PRIMARY KEY,
    nome TEXT,
    idade INT
);

-- Inserindo dados válidos na tabela
INSERT INTO tabela_com_problemas (nome, idade) 
    VALUES ('João', 30),
        ('Maria', 25),
        ('Carlos', 40),
        ('Ana', 35);

-- Simulando uma corrupção, inserindo dados errados manualmente
-- Esses inserts podem ser usados para simular valores "corrompidos"
INSERT INTO tabela_com_problemas (nome, idade) 
    VALUES ('José', NULL);  -- Vamos simular um erro de dados com idade NULL
INSERT INTO tabela_com_problemas (nome, idade) 
    VALUES (NULL, 50);  -- Vamos simular um erro de dados com nome NULL

DO $$
DECLARE 
    i bigint;               
    max_id bigint;          
    nome_corrompido text;   
    idade_corrompida int;
BEGIN
    SELECT max(id) INTO max_id FROM tabela_com_problemas;

    IF max_id IS NULL THEN
        RAISE NOTICE 'Tabela está vazia';
        RETURN;
    END IF;

    FOR i IN 1..max_id LOOP
        BEGIN
            SELECT nome, idade INTO nome_corrompido, idade_corrompida 
            FROM tabela_com_problemas WHERE id = i;
            
            -- Verifica se o valor é NULL para exemplificar nossos testes
            IF nome_corrompido IS NULL OR idade_corrompida IS NULL THEN
                RAISE NOTICE 'Linha corrompida: id = %, nome = %, idade = %', i, nome_corrompido, idade_corrompida;
            END IF;

        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Erro na linha com id = %', i;
        END;
    END LOOP;
END;
$$;

---------------------------------------------------------
-- Transactions corrompidas.
-- CREATE EXTENSION pg_surgery;
-- https://www.postgresql.org/docs/14/pgsurgery.html