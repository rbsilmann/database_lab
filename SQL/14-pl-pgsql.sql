-- Linguagem Procedural (PL/pgSQL) no PostgreSQL

-- 1. Usaremos o $$, mas por quê?
-- O delimitador $$ é utilizado para encapsular o bloco de código PL/pgSQL, permitindo evitar conflitos com o uso de apóstrofos ou aspas simples dentro do código.

DO $$
<<x>>
DECLARE
    x int := 0;
BEGIN
    x := x + 1;
    RAISE NOTICE 'O valor de x é %', x;
END x;
$$;

-- 2. Exemplo usando sub-blocos
-- Sub-blocos são útis para encapsular lógica isolada, criando escopos únicos para variáveis e código.
DO $$
<<x>>
DECLARE
    x int := 0;
BEGIN
    x := x + 1;
    <<y>>
    DECLARE
        y int := 2;
    BEGIN
        y := x + y;
        RAISE NOTICE 'O valor de x é % e y é %', x, y;
    END y;
END x;
$$;

-- 3. Explicando porque sub-blocos são útis
-- Sub-blocos permitem criar variáveis temporárias sem interferir no escopo principal.
DO $$
<<lab>>
DECLARE
    x int := 1;
    y int := 2;
BEGIN
    RAISE NOTICE 'Valor de X e Y: % %', x, y;

    <<sublab>>
    DECLARE
        x int := 5;
        y int := 7;
    BEGIN
        RAISE NOTICE 'Valor sub-bloco de X e Y: % %', x, y;
    END sublab;

    RAISE NOTICE 'Valor no bloco principal de X e Y: % %', x, y;
END lab;
$$;

-- 4. Criar uma função que diga se o valor é ímpar ou par
CREATE OR REPLACE FUNCTION verificar_paridade(valor INT) RETURNS TEXT AS $$
BEGIN
    IF valor % 2 = 0 THEN
        RETURN 'Par';
    ELSE
        RETURN 'Impar';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Teste da função
SELECT verificar_paridade(3);
SELECT verificar_paridade(8);

-- 5. Criar uma trigger que logue informações de deletes e updates na tabela gastos_financeiros
CREATE TABLE gastos_financeiros_log (
    id SERIAL PRIMARY KEY,
    operacao TEXT NOT NULL,
    registro JSONB NOT NULL,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_gastos_financeiros() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO gastos_financeiros_log (operacao, registro)
        VALUES (TG_OP, row_to_json(OLD));
    ELSIF TG_OP = 'UPDATE' THEN
        -- INSERT INTO gastos_financeiros_log (operacao, registro)
        -- VALUES (TG_OP, row_to_json(OLD));
        INSERT INTO gastos_financeiros_log (operacao, registro)
        VALUES (TG_OP, row_to_json(NEW));
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_gastos_financeiros
AFTER DELETE OR UPDATE
ON gastos_financeiros
FOR EACH ROW
EXECUTE FUNCTION log_gastos_financeiros();

-- Testar a trigger
-- Exemplo de update
UPDATE gastos_financeiros
SET valor = valor + 100
WHERE id = 1;

-- Exemplo de delete
DELETE FROM gastos_financeiros
WHERE id = 2;

-- Verificar os logs
SELECT * FROM gastos_financeiros_log;
