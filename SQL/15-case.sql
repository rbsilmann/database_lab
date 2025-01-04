-- Sintaxe
CASE
    WHEN condição1 THEN resultado1
    WHEN condição2 THEN resultado2
    ...
    ELSE resultado_padrao
END

-- Exemplo:
CREATE TABLE colaboradores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

INSERT INTO colaboradores (nome, salario)
VALUES ('Ana Silva', 1500.00),
    ('Carlos Pereira', 4500.00),
    ('Beatriz Oliveira', 5000.00),
    ('Eduardo Souza', 7000.00),
    ('Fernanda Costa', 8000.00),
    ('Gabriel Almeida', 4000.00),
    ('Juliana Santos', 6000.00),
    ('Ricardo Lima', 5500.00),
    ('Patrícia Rocha', 7200.00),
    ('Marcelo Andrade', 3200.00);

-- Usando o CASE para definir faixas.
SELECT id,
    nome,
    CASE
        WHEN salario < 2000 THEN 'Faixa 1'
        WHEN salario BETWEEN 2000 AND 5000 THEN 'Faixa 2'
        ELSE 'Faixa 3'
    END AS faixa_salarial
FROM colaboradores;

-- Usando o CASE para retornar resultados onde o nome começa com A ou o salário é acima de 4000
SELECT 
    nome, 
    salario
FROM colaboradores
WHERE 
    CASE 
        WHEN salario > 4000 THEN TRUE
        WHEN nome LIKE 'A%' THEN TRUE
        ELSE FALSE
    END;

SELECT id,
    nome,
    CASE
        WHEN salario > 8000 THEN salario * 1.2
        WHEN salario BETWEEN 5000 AND 8000 THEN salario * 1.1
        ELSE salario * 1.05
    END AS salario_ajustado
FROM colaboradores;

CREATE TABLE contatos (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	email VARCHAR(255),
	telefone VARCHAR(255)
);

INSERT INTO contatos (nome, email, telefone) 
VALUES
    ('Ana Silva', 'ana.silva@gmail.com', '11987654321'),
    ('Carlos Pereira', NULL, '21987654321'),
    ('Beatriz Oliveira', 'beatriz.oliveira@gmail.com', NULL),
    ('Eduardo Souza', NULL, NULL),
    ('Fernanda Costa', 'fernanda.costa@outlook.com', '31987654321'),
    ('Gabriel Almeida', NULL, '11912345678'),
    ('Juliana Santos', 'juliana.santos@gmail.com', NULL),
    ('Ricardo Lima', NULL, NULL),
    ('Patrícia Rocha', 'patricia.rocha@email.com', '21911223344'),
    ('Marcelo Andrade', NULL, '11987651234');

-- Usando o CASE para agrupar os dominios de email utilizados.
SELECT 
    CASE 
        WHEN email LIKE '%@gmail.com' THEN 'Gmail'
        WHEN email LIKE '%@outlook.com' THEN 'Outlook'
        ELSE 'Outros'
    END AS dominio_email,
    COUNT(*) AS total
FROM contatos
GROUP BY 
    CASE 
        WHEN email LIKE '%@gmail.com' THEN 'Gmail'
        WHEN email LIKE '%@outlook.com' THEN 'Outlook'
        ELSE 'Outros'
    END;

SELECT 
    nome, 
    COALESCE(email, telefone, 'Contato não disponível') AS contato
FROM 
    contatos;
