-- Active: 1716856021564@@127.0.0.1@5432@bancoguardado1405
--Resumo para Prova: Conceitos Necessários para Realizar a Atividade 6

--1. Estrutura do Banco de Dados Relacional

--Tabelas**: Conjuntos de dados organizados em colunas (campos) e linhas (registros).
--Colunas**: Atributos que definem os dados armazenados, incluindo tipos de dados como `VARCHAR`, `INTEGER`, `DATE`, etc.
--Chaves Primárias (PK)**: Colunas ou combinações de colunas que identificam univocamente cada registro na tabela.
--Chaves Estrangeiras (FK)**: Colunas que estabelecem relações entre tabelas diferentes, referenciando a chave primária de outra tabela.

--2. Comandos SQL Básicos

--SELECT**: Utilizado para consultar dados.
SELECT coluna1, coluna2 
FROM tabela 
WHERE condição;

--INSERT**: Utilizado para inserir novos registros.
INSERT INTO tabela (coluna1, coluna2) 
VALUES 
(valor1, valor2)
;

--UPDATE**: Utilizado para atualizar registros existentes.
UPDATE tabela 
SET coluna1 = valor1 
WHERE condição;

--DELETE**: Utilizado para deletar registros.
DELETE FROM tabela 
WHERE condição;

--3. Junções (JOINS)
--INNER JOIN**: Retorna registros que têm valores correspondentes em ambas as tabelas.
SELECT * 
FROM tabela1 
INNER JOIN tabela2 ON tabela1.coluna = tabela2.coluna;

--LEFT JOIN**: Retorna todos os registros da tabela à esquerda e os registros correspondentes da tabela à direita.

SELECT * 
FROM tabela1 
LEFT JOIN tabela2 ON tabela1.coluna = tabela2.coluna;

--RIGHT JOIN**: Retorna todos os registros da tabela à direita e os registros correspondentes da tabela à esquerda.
SELECT * 
FROM tabela1 
RIGHT JOIN tabela2 ON tabela1.coluna = tabela2.coluna;

--FULL OUTER JOIN**: Retorna todos os registros quando há correspondência em uma das tabelas.
SELECT * 
FROM tabela1 FULL 
OUTER JOIN tabela2 ON tabela1.coluna = tabela2.coluna;

--4. Subconsultas (Subqueries)
--Utilizadas para realizar consultas dentro de outras consultas.
SELECT coluna 
FROM tabela 
WHERE coluna IN (
    SELECT coluna 
    FROM tabela2 
    WHERE condição
);

--5. Funções de Agregação

--COUNT**: Conta o número de registros.
SELECT COUNT(*) 
FROM tabela;

--SUM**: Soma valores numéricos.
SELECT SUM(coluna) 
FROM tabela;

--AVG**: Calcula a média.
SELECT AVG(coluna) 
FROM tabela;

--MAX** e **MIN**: Encontram o valor máximo e mínimo.
SELECT MAX(coluna) 
FROM tabela;
SELECT MIN(coluna) 
FROM tabela;

-- 6. Claúsulas e Condições
--WHERE**: Filtra registros com base em uma condição.

SELECT * 
FROM tabela 
WHERE coluna = valor;

--GROUP BY**: Agrupa registros por uma ou mais colunas.

SELECT coluna, COUNT(*) 
FROM tabela 
GROUP BY coluna;

--HAVING**: Filtra registros depois de um agrupamento.
SELECT coluna, COUNT(*) 
FROM tabela 
GROUP BY coluna 
  HAVING COUNT(*) > 1;

--ORDER BY**: Ordena os resultados.

SELECT * 
FROM tabela 
ORDER BY coluna ASC/DESC;


--7. Operadores Lógicos e Comparativos
-- =, !=, <, >, <=, >=**: Operadores de comparação.
---AND, OR, NOT**: Operadores lógicos.
--LIKE**: Utilizado para buscar padrões em colunas de texto.
SELECT * 
FROM tabela 
WHERE coluna LIKE 'texto%';


--8. Consultas Complexas
--Consultas com várias junções**:
SELECT *
FROM tabela1
  JOIN tabela2 ON tabela1.coluna = tabela2.coluna
  JOIN tabela3 ON tabela2.coluna = tabela3.coluna
WHERE condição;

--Consultas com subconsultas**:
SELECT coluna
FROM tabela
WHERE coluna IN (
    SELECT coluna 
    FROM tabela2 
    WHERE condição
);


--Exemplos de Questões SQL para Prova

--Mostrar os filmes que nunca tiveram premiação
SELECT titulo_original, genero, class_etaria
FROM filme
WHERE cod_filme NOT IN (
    SELECT cod_filme
    FROM premiacao
);

--Mostrar as salas que nunca tiveram sessões dubladas para filmes de Ação ou Aventura produzidas pelos EUA (usando junção externa)
SELECT s.nome_sala, s.tipo_audio, s.capacidade_sala
FROM sala s
   LEFT JOIN sessao ss ON s.nome_sala = ss.nome_sala
   LEFT JOIN filme f ON ss.cod_filme = f.cod_filme
WHERE (f.genero = 'Ação' OR f.genero = 'Aventura')
    AND f.nacionalidade = 'EUA'
    AND ss.num_sessao IS NULL;


--Mostrar o filme norte-americano com a menor duração   
SELECT titulo_original, duracao_min, genero
FROM filme
WHERE nacionalidade = 'EUA'
   ORDER BY duracao_min ASC
   LIMIT 1;

--Mostrar o filme e a sessão que tiveram a maior taxa de ocupação
SELECT f.titulo_original, s.num_sessao, s.dt_sessao, s.cod_horario, s.publico, sl.capacidade_sala, 
        (s.publico / sl.capacidade_sala * 100) AS taxa_ocupacao
FROM filme f
   JOIN sessao s ON f.cod_filme = s.cod_filme
   JOIN sala sl ON s.nome_sala = sl.nome_sala
ORDER BY taxa_ocupacao DESC
   LIMIT 1;


--Mostrar as sessões deste ano que tiveram público maior que a média de público deste ano
SELECT s.num_sessao, s.dt_sessao, s.cod_horario, f.titulo_original, s.publico, 
    (
    SELECT AVG(publico)
    FROM sessao 
    WHERE EXTRACT(YEAR FROM dt_sessao) = EXTRACT(YEAR FROM CURRENT_DATE)) AS media_publico
FROM sessao s
    JOIN filme f ON s.cod_filme = f.cod_filme
WHERE EXTRACT(YEAR FROM s.dt_sessao) = EXTRACT(YEAR FROM CURRENT_DATE)
    AND s.publico > (
        SELECT AVG(publico)
        FROM sessao 
        WHERE EXTRACT(YEAR FROM dt_sessao) = EXTRACT(YEAR FROM CURRENT_DATE)
        );

--Mostrar todos os dados da sessão com maior rentabilidade (renda/público)
SELECT *
FROM sessao
ORDER BY (renda_sessao / publico) DESC
LIMIT 1;

UPDATE clientes SET id_cliente = 3 WHERE id_cliente = 1;
-- Isso também atualizará o id_cliente correspondente na tabela pedidos para 3

DELETE FROM clientes WHERE id_cliente = 3;
-- Isso também excluirá todos os registros correspondentes na tabela pedidos onde id_cliente = 3


   