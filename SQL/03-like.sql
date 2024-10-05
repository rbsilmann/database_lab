CREATE TABLE texto(
   mensagem text
);

INSERT INTO texto (mensagem) 
VALUES  ('Juros de 10% aplicado devido ao atraso'), 
        ('Email secundário é juninho_gameplay@gmail');

-- SELECT mensagem FROM texto WHERE mensagem ILIKE '%10$%%' ESCAPE '$';
-- SELECT mensagem FROM texto WHERE mensagem ILIKE '%$_%' ESCAPE '$';