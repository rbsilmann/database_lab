-- Tabela exemplo
CREATE TABLE sites (
    id SERIAL PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    descricao VARCHAR(255),
    last_update DATE
);

-- Inserindo nosso primeiro dado
INSERT INTO sites (url, nome)
VALUES ('https://www.postgresql.org/', 'PostgreSQL');

-- Validando os dados inseridos
SELECT *
FROM sites;

-- Caso nosso texto contenha o caractere reservado 
-- para strings ', precisamos usar um adicional '
INSERT INTO sites (url, nome)
VALUES ('http://www.oreilly.com', 'O''Reilly Media');

-- Para inserir datas usamos o padrão AAAA-MM-DD
INSERT INTO sites (url, nome, last_update)
VALUES ('https://www.google.com', 'Google', '2024-10-31');

-- Também podemos retornar informações recém inseridas que não temos acesso no
-- momento da inserção
INSERT INTO sites (url, nome, last_update)
VALUES ('https://www.outlook.com', 'Outlook', '2024-10-31')
RETURNING *;

-- Também podemos retornar informações recém inseridas que não temos acesso no
-- momento da inserção, especificando a(s) coluna(s)
INSERT INTO sites (url, nome, last_update)
VALUES ('https://www.petz.com.br', 'Petz', '2024-10-31')
RETURNING id;

-- Para simplificar escrita e leitura, podemos inserir multiplos registros em
-- apenas um statement
INSERT INTO sites (url, nome, last_update)
VALUES 
    ('https://maillllllll.google.com', 'Gmaillllllll', '2024-10-31'),
    ('https://chat.google.com', 'Google Chat', '2024-10-31'),
    ('https://drive.google.com', 'Google Drive', '2024-10-31'),
    ('https://calendar.google.com', 'Google Agenda', '2024-10-31')
RETURNING *;

-- Modificando um dado existente e exibindo o resultado da atualização
UPDATE sites
SET url = 'https://mail.google.com',
    nome = 'Gmail'
WHERE id = [id Gmail]
RETURNING *;

-- Usando expressões para atualizar dados
UPDATE sites
SET last_update = last_update - INTERVAL '1 day'
WHERE id = [id Gmail]
RETURNING *;

-- Update usando JOIN, vamos criar os dados que utilizaremos no exemplo

CREATE TABLE setor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

INSERT INTO setor (nome)
VALUES 
    ('Suporte'),
    ('Diretoria'),
    ('Desenvolvimento'),
    ('Operacoes');

CREATE TABLE funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    salario NUMERIC(10,2) NOT NULL,
    id_setor INT REFERENCES setor(id) NOT NULL
);

INSERT INTO funcionario (nome, salario, id_setor) 
VALUES
    ('Alice Souza', 3500.00, 1),
    ('Bruno Pereira', 4200.00, 2),
    ('Carlos Lima', 5000.00, 3),
    ('Daniela Santos', 2800.00, 4),
    ('Eduardo Oliveira', 3900.00, 1),
    ('Fernanda Costa', 4500.00, 2),
    ('Gabriel Souza', 5200.00, 3),
    ('Helena Mendes', 3100.00, 4),
    ('Iago Silva', 3700.00, 1),
    ('Julia Fernandes', 4600.00, 2),
    ('Lucas Andrade', 5100.00, 3),
    ('Mariana Rocha', 2900.00, 4),
    ('Nicolas Ribeiro', 3300.00, 1),
    ('Olivia Duarte', 4000.00, 2),
    ('Paulo Correia', 4800.00, 3),
    ('Rafaela Gomes', 2700.00, 4),
    ('Sofia Almeida', 3400.00, 1),
    ('Thiago Martins', 4300.00, 2);


-- Para o update precisamos informar após a coluna que será atualizada, a tabela que
-- faremos a junção e em seguida utilizaremos na condição quais campos devem coincidir
UPDATE funcionario f
SET salario = salario * 1.06
FROM setor s
WHERE f.id_setor = s.id
AND s.id = 1;

-- Sintaxe do delete
DELETE FROM funcionario
WHERE id_setor = 4
RETURNING *;

-- Delete 'JOIN' não existe no PostgreSQL, mas podemos usar uma forma similar
INSERT INTO setor (nome)
VALUES ('Marketing');

INSERT INTO funcionario (nome, salario, id_setor) 
VALUES
    ('Daniela Santos', 2800.00, 5),
    ('Helena Mendes', 3100.00, 5),
    ('Mariana Rocha', 2900.00, 5),
    ('Rafaela Gomes', 2700.00, 5);

DELETE FROM funcionario
USING setor
WHERE funcionario.id_setor = setor.id
AND setor.id = 5;

-- Opcionalmente utilizamos também por subconsultas

DELETE FROM funcionario
WHERE id_setor IN (
    SELECT id 
    FROM setor 
    WHERE id = 5
);

-- Upsert, a arte de inserir uma linha se ela não existir ou atualizar a linha se 
-- existir

TRUNCATE TABLE funcionario;

INSERT INTO funcionario (nome, salario, id_setor) 
VALUES
    ('Alice Souza', 3500.00, 1),
    ('Bruno Pereira', 4200.00, 2),
    ('Carlos Lima', 5000.00, 3),
    ('Daniela Santos', 2800.00, 4),
    ('Eduardo Oliveira', 3900.00, 1),
    ('Fernanda Costa', 4500.00, 2),
    ('Gabriel Souza', 5200.00, 3),
    ('Helena Mendes', 3100.00, 4),
    ('Iago Silva', 3700.00, 1),
    ('Julia Fernandes', 4600.00, 2),
    ('Lucas Andrade', 5100.00, 3),
    ('Mariana Rocha', 2900.00, 4),
    ('Nicolas Ribeiro', 3300.00, 1),
    ('Olivia Duarte', 4000.00, 2),
    ('Paulo Correia', 4800.00, 3),
    ('Rafaela Gomes', 2700.00, 4),
    ('Sofia Almeida', 3400.00, 1),
    ('Thiago Martins', 4300.00, 2)
ON CONFLICT (id)
-- DO NOTHING para não fazer nada
-- DO UPDATE para realizar as atualizações nos conflitos
DO UPDATE SET
    nome = EXCLUDED.nome,
    salario = EXCLUDED.salario,
    id_setor = EXCLUDED.id_setor;

SELECT * FROM funcionario;

-- Colocar os IDs gerados
-- Aqui estamos utilizando a palavra-chave EXCLUDED. 
-- Quando ocorre um conflito, o PostgreSQL cria um registro temporário chamado 
-- EXCLUDED que armazena os valores que foram enviados pelo INSERT original. 
-- Ao usarmos EXCLUDED.price e EXCLUDED.quantity, estamos dizendo que queremos 
-- atualizar o registro existente com os novos valores price e quantity que foram 
-- passados na tentativa inicial de inserção.
-- Resumindo a lógica: "insira se não existir, atualize se existir"
INSERT INTO funcionario (id, nome, salario, id_setor) 
VALUES
    (59, 'Alice Souza Melo', 3550.00, 1),
    (60, 'Bruno Pereira Amorim', 4500.00, 2),
    (61, 'Carlos Lima Melo', 6000.00, 3),
    (62, 'Daniela Silva Santos', 3000.00, 4)
ON CONFLICT (id)
-- DO NOTHING
-- DO UPDATE
DO UPDATE SET
    nome = EXCLUDED.nome,
    salario = EXCLUDED.salario,
    id_setor = EXCLUDED.id_setor;
