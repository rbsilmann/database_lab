-- ACCESS SHARE
BEGIN;
SELECT * FROM colaboradores;
-- Enquanto este lock está ativo, outra transação pode fazer SELECT,
-- mas não pode alterar ou excluir a tabela "produtos".

-- ROW SHARE
BEGIN;
SELECT * FROM colaboradores FOR UPDATE;
-- A linha correspondente ao produto com id = 1 será bloqueada para alterações
-- por outras transações até que esta transação seja concluída.

-- ACCESS EXCLUSIVE
BEGIN;
DROP TABLE colaboradores;
-- Nenhuma outra operação na tabela "colaboradores" é permitida até o término desta transação.

-- FOR UPDATE
BEGIN;
SELECT * FROM colaboradores WHERE id = 1 FOR UPDATE;
-- A linha do colaboradore com id 1 está bloqueada para alterações
-- até que esta transação termine.

-- FOR NO KEY UPDATE
BEGIN;
SELECT * FROM colaboradores WHERE id = 1 FOR NO KEY UPDATE;
-- A linha do cliente com id = 1 está bloqueada para modificações diretas,
-- mas índices relacionados podem ser atualizados por outras transações.

-- FOR SHARE
BEGIN;
SELECT * FROM colaboradores WHERE id = 1 FOR SHARE;
-- As linhas dos colaboradores com id = 1 estão protegidas contra exclusão,
-- mas podem ser lidas ou bloqueadas por outras transações no mesmo nível.

-- FOR KEY SHARE
BEGIN;
SELECT * FROM colaboradores WHERE status = 'ativo' FOR KEY SHARE;
-- As linhas dos colaboradores com id = 1 estão protegidas contra alterações
-- nas chaves primárias, mas podem ser alteradas em outros campos.

-- VISUALIZAR LOCKs
SELECT * FROM pg_locks;