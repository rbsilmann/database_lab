CREATE TABLE alunos (
	id serial PRIMARY KEY,
	primeiro_nome varchar(255) NOT NULL,
	ultimo_nome varchar(255) NOT NULL,
	idade int NOT NULL,
	data_cadastro date NOT NULL DEFAULT now()
);
