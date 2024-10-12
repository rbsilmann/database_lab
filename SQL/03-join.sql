-- SELECT * FROM banco;
-- SELECT * FROM bancoconfiguracao;

-- SELECT  b.descricao AS descricao_nome_banco, 
--         bc.*
-- FROM banco AS b
-- INNER JOIN bancoconfiguracao bc ON b.id = bc.id_banco
-- ORDER BY descricao_nome_banco;

CREATE TABLE cesta_a (
    a INT PRIMARY KEY,
    fruta_a VARCHAR (100) NOT NULL
);

CREATE TABLE cesta_b (
    b INT PRIMARY KEY,
    fruta_b VARCHAR (100) NOT NULL
);

INSERT INTO cesta_a (a, fruta_a)
VALUES
    (1, 'Maça'),
    (2, 'Laranja'),
    (3, 'Banana'),
    (4, 'Abacaxi');

INSERT INTO cesta_b (b, fruta_b)
VALUES
    (1, 'Laranja'),
    (2, 'Maça'),
    (3, 'Melancia'),
    (4, 'Pêra');

-- Une e cria novas linhas apenas nas chaves que tem correspondências
SELECT a, fruta_a,
	b, fruta_b
FROM cesta_a
INNER JOIN cesta_b ON fruta_a = fruta_b;

-- Une e cria novas linhas com as colunas a esquerda, mesmo que à direita não haja correspondências, popula com nulos
SELECT a, fruta_a,
	b, fruta_b
FROM cesta_a
LEFT JOIN cesta_b ON fruta_a = fruta_b;

-- Une e cria novas linhas com as colunas a direita, mesmo que esquerda não haja correspondências, popula com nulos
SELECT a, fruta_a,
	b, fruta_b
FROM cesta_a
RIGHT JOIN cesta_b ON fruta_a = fruta_b;

-- Une e cria novas linhas mesmo que não haja todas as correspondências, verifica primeiro a esquerda e depois a direita
SELECT a, fruta_a,
	b, fruta_b
FROM cesta_a
FULL JOIN cesta_b ON fruta_a = fruta_b;

-- Exemplo sistema
SELECT  b.descricao AS descricao_nome_banco, 
        bc.*
FROM banco AS b
INNER JOIN bancoconfiguracao bc ON b.id = bc.id_banco
ORDER BY descricao_nome_banco;

-- Produto cartesiano
CREATE TABLE cross_a (
    numeros INT NOT NULL
);

CREATE TABLE cross_b (
    letras VARCHAR (100) NOT NULL
);

INSERT INTO cross_a (numeros)
VALUES
    (1),
    (2),
    (3);

INSERT INTO cross_b (letras)
VALUES
    ('a'),
    ('b'),
    ('c');

SELECT a.numeros, 
    b.letras
FROM cross_a AS a
CROSS JOIN cross_b AS b;
