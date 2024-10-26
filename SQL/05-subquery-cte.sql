-- DROP TABLE menu
CREATE TABLE menu (
	id SERIAL PRIMARY KEY,
	descricao VARCHAR(255) NOT NULL
);

INSERT INTO menu(descricao) VALUES ('MENU');

-- DROP TABLE menu_item
CREATE TABLE menu_item (
	id SERIAL PRIMARY KEY,
	descricao VARCHAR(255) NOT NULL,
	id_menu INT REFERENCES menu(id)
);

INSERT INTO menu_item(descricao, id_menu) VALUES ('ITEM 1', 1);
INSERT INTO menu_item(descricao, id_menu) VALUES ('ITEM 2', 1);
INSERT INTO menu_item(descricao, id_menu) VALUES ('ITEM 3', 1);
INSERT INTO menu_item(descricao, id_menu) VALUES ('ITEM 4', 1);
INSERT INTO menu_item(descricao, id_menu) VALUES ('ITEM 5', 1);

-- DROP TABLE menu_subitem
CREATE TABLE menu_subitem (
	id SERIAL PRIMARY KEY,
	descricao VARCHAR(255) NOT NULL,
	id_menu_item INT REFERENCES menu_item(id)
);

INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 1', 1);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 2', 1);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 3', 1);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 1', 2);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 2', 2);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 3', 2);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 1', 3);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 2', 3);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 3', 4);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 1', 4);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 2', 4);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 3', 4);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 1', 5);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 2', 5);
INSERT INTO menu_subitem(descricao, id_menu_item) VALUES ('SUBITEM 3', 5);

SELECT 
	m.descricao || ' >> ' || mi.descricao || ' >> ' || msi.descricao AS caminho_menu
FROM
	menu_subitem msi
INNER JOIN menu_item mi ON mi.id = msi.id_menu_item
INNER JOIN menu m ON m.id = mi.id_menu
WHERE msi.id = 4 -- IS NULL

UNION

SELECT 
	m.descricao || ' >> ' || mi.descricao AS caminho_menu
FROM
	menu_item mi
INNER JOIN menu m ON m.id = mi.id_menu
WHERE mi.id = 2 -- IS NULL

UNION

SELECT 
	m.descricao AS caminho_menu
FROM
	menu m
WHERE m.id = 1
ORDER BY caminho_menu

-- Com recursividade

CREATE TABLE menu_recursivo (
	id SERIAL PRIMARY KEY,
	descricao VARCHAR(255),
	id_pai INT REFERENCES menu_recursivo(id)
)

INSERT INTO menu_recursivo (descricao) VALUES ('MENU');
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 1', 1);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 2', 1);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 3', 1);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 4', 1);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 5', 1);

-- SELECT * FROM menu_recursivo;

INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 1', 1);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 2', 1);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 3', 1);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 4', 1);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('ITEM 5', 1);

-- SELECT * FROM menu_recursivo;

INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 1', 2);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 2', 2);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 3', 2);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 1', 3);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 2', 3);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 3', 3);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 1', 4);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 2', 4);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 3', 4);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 1', 5);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 2', 5);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 3', 5);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 1', 6);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 2', 6);
INSERT INTO menu_recursivo (descricao, id_pai) VALUES ('SUBITEM 3', 6);

-- SELECT * FROM menu_recursivo;

SELECT 
	mr.id,
	mr.descricao,
	mr.id_pai
FROM menu_recursivo mr
WHERE mr.id = 9

-- Pego o id_pai e faço a mesma consulta

SELECT 
	mr.id,
	mr.descricao,
	mr.id_pai
FROM menu_recursivo mr
WHERE mr.id = 2

-- Pego o id_pai e faço a mesma consulta

SELECT 
	mr.id,
	mr.descricao,
	mr.id_pai
FROM menu_recursivo mr
WHERE mr.id = 1

WITH RECURSIVE menu_cte AS (
	-- Consulta âncora, servirá de base para a recursividade
	SELECT 
		mr.id,
		mr.descricao,
		mr.id_pai
	FROM menu_recursivo mr
	WHERE mr.id = 8

	UNION ALL

	SELECT
		mrj.id,
		mrj.descricao,
		mrj.id_pai
	FROM menu_cte mc
	INNER JOIN menu_recursivo mrj ON mrj.id = mc.id_pai
)

SELECT
	mc.id,
	mc.descricao
FROM menu_cte mc
ORDER BY mc.id

-- Produzindo o mesmo resultado

WITH RECURSIVE menu_cte AS (
    -- Consulta âncora
    SELECT 
        mr.id,
        mr.descricao,
        mr.id_pai,
        1 AS nivel
    FROM menu_recursivo mr
    WHERE mr.id = 8

    UNION ALL

    -- Consulta recursiva
    SELECT
        mrj.id,
        mrj.descricao,
        mrj.id_pai,
        mc.nivel + 1 AS nivel
    FROM menu_cte mc
    INNER JOIN menu_recursivo mrj ON mrj.id = mc.id_pai
)

SELECT
    string_agg(mc.descricao, ' >> ' ORDER BY mc.nivel DESC) AS caminho_menu
FROM menu_cte mc;
