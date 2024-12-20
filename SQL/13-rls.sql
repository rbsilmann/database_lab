-- 1. Criar a tabela de gastos financeiros com a coluna da role
CREATE TABLE gastos_financeiros (
    id SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL,
    valor NUMERIC(10, 2) NOT NULL,
    data_gasto DATE NOT NULL DEFAULT CURRENT_DATE,
    role_name TEXT NOT NULL
);

-- 2. Criar as roles
CREATE ROLE vendas;
CREATE ROLE compras;
CREATE ROLE suporte;
CREATE ROLE desenvolvimento;
CREATE ROLE financeiro;

-- Inserindo registros para teste
INSERT INTO gastos_financeiros (descricao, valor, data_gasto, role_name)
VALUES 
    ('Compra de materiais de escritório', 350.00, '2024-12-01', 'compras'),
    ('Venda de produtos A', 1250.00, '2024-12-02', 'vendas'),
    ('Pagamento de licença de software', 800.00, '2024-12-03', 'suporte'),
    ('Desenvolvimento de novo sistema', 2000.00, '2024-12-04', 'desenvolvimento'),
    ('Relatório financeiro mensal', 0.00, '2024-12-05', 'financeiro'),
    ('Compra de hardware', 4500.00, '2024-12-06', 'compras'),
    ('Comissão de vendas - equipe B', 1500.00, '2024-12-07', 'vendas'),
    ('Manutenção de servidores', 300.00, '2024-12-08', 'suporte'),
    ('Projeto de melhoria contínua', 1800.00, '2024-12-09', 'desenvolvimento'),
    ('Análise de custos operacionais', 0.00, '2024-12-10', 'financeiro');

-- Garantir permissões básicas de SELECT e INSERT para as roles
GRANT SELECT, INSERT ON TABLE gastos_financeiros TO vendas, compras, suporte, desenvolvimento;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE gastos_financeiros_id_seq TO vendas, compras, suporte, desenvolvimento;

-- Garantir todas as permissões para o financeiro
GRANT ALL ON TABLE gastos_financeiros TO financeiro;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE gastos_financeiros_id_seq TO financeiro;

-- 3. Habilitar o RLS na tabela
ALTER TABLE gastos_financeiros ENABLE ROW LEVEL SECURITY;

SET ROLE financeiro;

SELECT * FROM gastos_financeiros;

RESET ROLE;

-- 4. Criar as políticas
-- Política para permitir ao financeiro acesso total (SELECT, INSERT, UPDATE, DELETE)
CREATE POLICY financeiro_policy
ON gastos_financeiros
FOR ALL
TO financeiro
USING (true) -- significa que qualquer linha da tabela será visível para a role financeiro (não há restrição)
WITH CHECK (true); -- significa que não há restrição nos dados que podem ser inseridos ou atualizados pela role financeiro.

-- Política para permitir SELECT para registros da própria role
CREATE POLICY role_policy_select
ON gastos_financeiros
FOR SELECT
TO vendas, compras, suporte, desenvolvimento
USING (role_name = current_user);

-- Política para permitir INSERT somente com role_name igual ao current_user
CREATE POLICY role_policy_insert
ON gastos_financeiros
FOR INSERT
TO vendas, compras, suporte, desenvolvimento
WITH CHECK (role_name = current_user);

-- 5. Garantir que somente as roles tenham acesso à tabela
REVOKE ALL ON gastos_financeiros FROM PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON gastos_financeiros TO financeiro;
GRANT SELECT, INSERT ON gastos_financeiros TO vendas, compras, suporte, desenvolvimento;

-- 6. Forçar RLS (opcional)
ALTER TABLE gastos_financeiros FORCE ROW LEVEL SECURITY;

-- 7. Associar usuários às roles
GRANT vendas TO usuario_vendas;
GRANT compras TO usuario_compras;
GRANT suporte TO usuario_suporte;
GRANT desenvolvimento TO usuario_desenvolvimento;
GRANT financeiro TO usuario_financeiro;
