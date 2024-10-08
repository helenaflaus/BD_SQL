-- Active: 1716856021564@@127.0.0.1@5432@banquinho_P2
-- Criação das tabelas
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    data_nascimento DATE
);



CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100),
    categoria VARCHAR(50),
    preco DECIMAL(10, 2)
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    data_pedido DATE,
    valor_total DECIMAL(10, 2)
);

CREATE TABLE status_pedido (
    id_pedido INT REFERENCES pedidos(id_pedido),
    status VARCHAR(50),
    data_status DATE,
    PRIMARY KEY (id_pedido, status)
);

-- Inserção de dados na tabela clientes
INSERT INTO clientes (nome, email, data_nascimento) VALUES 
('João Silva', 'joao@example.com', '1980-01-01'),
('Maria Oliveira', 'maria@example.com', '1990-05-15'),
('Carlos Souza', 'carlos@example.com', '1985-07-23');

-- Inserção de dados na tabela produtos
INSERT INTO produtos (nome_produto, categoria, preco) VALUES 
('Notebook', 'Eletrônicos', 2500.00),
('Smartphone', 'Eletrônicos', 1500.00),
('Cadeira', 'Móveis', 350.00);

-- Inserção de dados na tabela pedidos
INSERT INTO pedidos (id_cliente, data_pedido, valor_total) VALUES 
(1, '2023-01-10', 2500.00),
(2, '2023-01-11', 1500.00),
(3, '2023-01-12', 350.00);

-- Inserção de dados na tabela status_pedido
INSERT INTO status_pedido (id_pedido, status, data_status) VALUES 
(1, 'enviado', '2023-01-11'),
(2, 'em processamento', '2023-01-12'),
(3, 'entregue', '2023-01-13');

-- Adicionando novas tabelas para tornar o banco mais complexo
CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(100)
);

CREATE TABLE produtos_categorias (
    id_produto INT REFERENCES produtos(id_produto),
    id_categoria INT REFERENCES categorias(id_categoria),
    PRIMARY KEY (id_produto, id_categoria)
);

-- Inserindo dados na tabela categorias
INSERT INTO categorias (nome_categoria) VALUES 
('Eletrônicos'), ('Móveis'), ('Vestuário');

-- Relacionando produtos com categorias
INSERT INTO produtos_categorias (id_produto, id_categoria) VALUES 
(1, 1), (2, 1), (3, 2);

-- Adicionando mais dados às tabelas existentes
INSERT INTO clientes (nome, email, data_nascimento) VALUES 
('Ana Lima', 'ana@example.com', '1992-03-17'),
('Pedro Marques', 'pedro@example.com', '1988-09-09');

INSERT INTO produtos (nome_produto, categoria, preco) VALUES 
('Mesa', 'Móveis', 450.00),
('Camisa', 'Vestuário', 80.00);

INSERT INTO clientes (nome, email, data_nascimento) VALUES 
('Juliana Pereira', 'juliana@example.com', '1995-04-10'),
('Rafael Martins', 'rafael@example.com', '1982-08-22'),
('Fernanda Costa', 'fernanda@example.com', '1977-11-05'),
('Bruno Ferreira', 'bruno@example.com', '1988-03-30'),
('Aline Rodrigues', 'aline@example.com', '1990-12-17');

INSERT INTO produtos (nome_produto, categoria, preco) VALUES 
('Sofá', 'Móveis', 1200.00),
('Televisão', 'Eletrônicos', 1800.00),
('Geladeira', 'Eletrodomésticos', 2500.00),
('Fogão', 'Eletrodomésticos', 900.00),
('Calça', 'Vestuário', 120.00);

INSERT INTO categorias (nome_categoria) VALUES 
('Eletrodomésticos');

INSERT INTO produtos_categorias (id_produto, id_categoria) VALUES 
(7, 2), (8, 1), (9, 4), (10, 4);

INSERT INTO pedidos (id_cliente, data_pedido, valor_total) VALUES 
(1, '2023-03-01', 3000.00),
(2, '2023-03-02', 1800.00),
(3, '2023-03-03', 2500.00),
(4, '2023-03-04', 900.00),
(5, '2023-03-05', 120.00),
(6, '2023-03-06', 1200.00),
(7, '2023-03-07', 1800.00),
(8, '2023-03-08', 2500.00),
(9, '2023-03-09', 900.00),
(10, '2023-03-10', 120.00);

INSERT INTO status_pedido (id_pedido, status, data_status) VALUES 
(6, 'enviado', '2023-03-07'),
(7, 'em processamento', '2023-03-08'),
(8, 'entregue', '2023-03-09'),
(9, 'enviado', '2023-03-10'),
(10, 'em processamento', '2023-03-11');


CREATE TABLE pedido_produto (
    id_pedido INT REFERENCES pedidos(id_pedido),
    id_produto INT REFERENCES produtos(id_produto),
    quantidade INT,
    preco_unitario DECIMAL(10, 2),
    PRIMARY KEY (id_pedido, id_produto)
);

INSERT INTO pedido_produto (id_pedido, id_produto, quantidade, preco_unitario) VALUES 
(1, 1, 2, 2500.00),
(1, 2, 1, 1500.00),
(2, 3, 4, 350.00),
(14, 4, 1, 450.00),
(3, 5, 3, 80.00),
(11, 1, 1, 2500.00),
(13, 2, 2, 1500.00),
(6, 3, 1, 350.00),
(7, 4, 1, 450.00),
(8, 5, 2, 80.00);


----------- QUERY
--Perguntas de Diferentes Níveis de Dificuldade

--Nível Básico
--Qual é o nome e o email dos clientes que têm o aniversário em janeiro?
SELECT * FROM clientes;

SELECT 	
	nome, 
	email,
	data_nascimento
FROM clientes
WHERE EXTRACT (MONTH FROM data_nascimento) = 01;

SELECT nome, email, data_nascimento
FROM clientes
WHERE DATE_PART('month', data_nascimento) = 1;


--Quantos produtos existem na categoria 'Eletrônicos'?
SELECT * FROM produtos ;
SELECT * FROM categorias ;
SELECT * FROM produtos_categorias ;

SELECT COUNT(*) as "Quantidade de produtos na categoria Eletrônicos"
FROM produtos_categorias
WHERE id_categoria = 1;

--Quais são os nomes dos produtos e seus preços?
SELECT 
	nome_produto AS "Nome Produto",
	preco AS "Preço Produto"
FROM produtos ; 

--Liste todos os pedidos com seus respectivos valores totais.
SELECT * FROM pedidos ;

SELECT 
	id_pedido AS "Pedido",
	valor_total AS "Valor Total"
FROM pedidos ;

--Nível Intermediário
--Quais são os produtos que custam mais de R$ 500,00?
SELECT * FROM produtos ;

SELECT 
	nome_produto AS "Produtos que custam mais de R$ 500,00",
	preco AS "Preço Produto"
FROM produtos
WHERE preco > 500 ;

--Quantos pedidos foram feitos por cada cliente?
SELECT * FROM pedidos ;
SELECT * FROM clientes ;
	
	--para mostrar o nome do cliente juntando com tabela clientes
SELECT 
	c.nome AS "Nome do Cliente",
	COUNT(p.id_pedido) AS "Pedidos por cliente"
FROM pedidos p 
JOIN clientes c ON p.id_cliente = c.id_cliente
GROUP BY(c.nome) ;
	
	--versão simplificada apenas com codigo do cliente da tabela pedidos
SELECT COUNT(id_pedido) AS "Pedidos por cliente",
	id_cliente AS "Código Cliente"
FROM pedidos
GROUP BY id_cliente ;


--Qual é a soma total dos valores dos pedidos realizados em março fevereiro de 2023?
--s1
SELECT * FROM pedidos ;
SELECT SUM(valor_total) AS "Valor total pedidos de março 2023"
FROM pedidos
WHERE data_pedido >= '2023-03-01' AND data_pedido <= '2023-03-31';
--s2
SELECT SUM(valor_total) AS "Valor total pedidos de março 2023"
FROM pedidos
WHERE data_pedido BETWEEN '2023-03-01' AND '2023-03-31' ;

--Liste todos os pedidos com o status 'enviado'.
SELECT * FROM status_pedido ;

SELECT p.id_pedido AS "Código do Pedido",
	sp.status AS "Status do Pedido"
FROM pedidos p
JOIN status_pedido sp ON p.id_pedido = sp.id_pedido
WHERE status = 'enviado' ;

--Nível Avançado
--Qual é a média de valor dos pedidos para cada cliente?
SELECT 
	nome AS "Nome Cliente",
	AVG(valor_total) AS "Média Valor dos Pedidos"
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
GROUP BY (c.nome) ;

SELECT 
    c.id_cliente AS "ID do Cliente",
    c.nome AS "Nome do Cliente",
    AVG(p.valor_total) AS "Média de Valor dos Pedidos"
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome;

--Quais são os produtos e suas categorias? Use JOINs para juntar as tabelas necessárias.
SELECT nome_produto AS "Nome Produto",
	nome_categoria AS "Categoria"
FROM categorias c
JOIN produtos_categorias pc ON c.id_categoria = pc.id_categoria
JOIN produtos p ON pc.id_produto = p.id_produto ;

--Quais produtos têm o segundo maior preço em cada categoria? Use funções analíticas.
SELECT
    nome_produto,
    categoria,
    preco
FROM (
    SELECT
        p.nome_produto,
        p.preco,
        c.nome_categoria AS categoria,
        DENSE_RANK() OVER (PARTITION BY c.nome_categoria ORDER BY p.preco DESC) AS rank
    FROM
        produtos p
    JOIN
        produtos_categorias pc ON p.id_produto = pc.id_produto
    JOIN
        categorias c ON pc.id_categoria = c.id_categoria
) subquery
WHERE rank = 2;


WITH RankedProducts AS (
    SELECT
        p.nome_produto,
        p.preco,
        c.nome_categoria AS categoria,
        DENSE_RANK() OVER (PARTITION BY c.nome_categoria ORDER BY p.preco DESC) AS rank
    FROM
        produtos p
    JOIN
        produtos_categorias pc ON p.id_produto = pc.id_produto
    JOIN
        categorias c ON pc.id_categoria = c.id_categoria
)
SELECT
    nome_produto,
    categoria,
    preco
FROM
    RankedProducts
WHERE
    rank = 2;


--Quais clientes têm mais de um pedido com status 'em processamento'?
SELECT
	nome AS "Nome do Cliente",
    COUNT(p.id_pedido) AS "Qntd Pedidos"
FROM clientes c
JOIN pedidos p ON p.id_cliente = c.id_cliente
JOIN status_pedido sp ON p.id_pedido = sp.id_pedido
WHERE sp.status = 'em processamento'
GROUP BY c.nome
HAVING COUNT(p.id_pedido) > 1;


--Quais são os clientes que fizeram pedidos superiores a R$ 2000,00 em março de 2023?
SELECT 
	nome AS "Cliente",
	valor_total AS "Valor Total Pedido",
	data_pedido AS "Data Pedido"
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE valor_total > 2000 AND (data_pedido BETWEEN '2023-03-01' AND '2023-03-31') ;

SELECT * 
FROM pedidos 
WHERE valor_total > 2000 AND (data_pedido BETWEEN '2023-03-01' AND '2023-03-31') ;

 
--Calcule o valor total dos pedidos por categoria de produto.
SELECT 
	SUM(valor_total) AS "Valor Total dos Pedidos",
	categoria AS "Categoria"
FROM produtos pr
JOIN pedido_produto pp ON pr.id_produto = pp.id_produto
JOIN pedidos p ON p.id_pedido = pp.id_pedido
GROUP BY(pr.categoria) ;


--Quais são os produtos que tiveram um valor de pedido médio superior a R$ 1000,00 em março de 2023?
SELECT 	
	AVG(valor_total) AS "Valor Pedido Médio",
	nome_produto AS "Nome Produto"
FROM produtos pr	
JOIN pedido_produto pp ON pr.id_produto = pp.id_produto
JOIN pedidos p ON p.id_pedido = pp.id_pedido
WHERE p.data_pedido BETWEEN '2023-03-01' AND '2023-03-31'
GROUP BY(pr.nome_produto)
HAVING AVG(p.valor_total) > 1000 ;


--Liste os pedidos que foram feitos por clientes que nasceram antes de 1985.
SELECT 
	id_pedido AS "Pedidos",
	nome AS "Nome Cliente",
	data_nascimento AS "Data de Nascimento"
FROM pedidos p 
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE data_nascimento < '1985-01-01' ;



--Encontre os produtos que foram vendidos mais de 1 vez em março de 2023.
WITH Vendido1vezmais AS (
	SELECT 
    	pp.id_produto,
    	COUNT(pp.id_produto) AS quantidade_pedidos
	FROM pedido_produto pp
	GROUP BY pp.id_produto
	HAVING COUNT(pp.id_produto) > 1
)
SELECT 
	v.id_produto, 
	p.data_pedido,
	pr.nome_produto
FROM Vendido1vezmais v
JOIN pedido_produto pp ON pp.id_produto = v.id_produto
JOIN pedidos p ON p.id_pedido = pp.id_pedido
JOIN produtos pr ON pr.id_produto = pp.id_produto
WHERE data_pedido BETWEEN '2023-03-01' AND '2023-03-31' ;


--Mostre a quantidade de pedidos e o valor total arrecadado por cada cliente.
SELECT 
	COUNT(id_pedido) AS quantidade_pedidos,
	SUM(valor_total) AS valor_total_por_cliente,
	id_cliente
FROM pedidos
GROUP BY id_cliente 
ORDER BY id_cliente;

SELECT 
	c.id_cliente,
    c.nome AS nome_cliente,
    COUNT(p.id_pedido) AS quantidade_pedidos,
    SUM(p.valor_total) AS valor_total_por_cliente
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY c.id_cliente;


--Liste os produtos que nunca foram vendidos.
SELECT
    pr.nome_produto,
	pp.quantidade AS quantidade_pedidos
FROM produtos pr
LEFT JOIN pedido_produto pp ON pp.id_produto = pr.id_produto
WHERE pp.id_produto IS NULL;



--Quais são os clientes que fizeram pedidos em todas as categorias de produtos?



--Calcule a média de idade dos clientes que fizeram pedidos em março de 2023.



--Quais são os produtos que foram vendidos para clientes diferentes no mesmo dia?



--Nível Especialista
--Qual é o valor total gasto por cada cliente, mostrando os resultados ordenados pelo maior valor total gasto?


--Liste o nome dos clientes, o nome dos produtos que eles compraram, e a data do pedido. Use múltiplos JOINs.


--Qual é a média cumulativa do preço dos produtos na categoria 'Móveis'? Use funções analíticas.


--Quais são os três pedidos mais recentes com status 'em processamento'?


--Calcule a taxa de crescimento mensal dos valores dos pedidos realizados em 2023.


--Calcule a taxa de crescimento mensal dos valores dos pedidos realizados em 2023.


--Liste o nome dos clientes, o nome dos produtos que eles compraram, e a data do pedido, ordenando pelos clientes que gastaram mais.


--Encontre os três clientes que fizeram o maior número de pedidos no primeiro trimestre de 2023.


--Liste todos os produtos, a quantidade de vezes que foram vendidos, e a data da última venda.


--Mostre os pedidos que têm a maior variação de valor em relação à média de valores dos pedidos feitos no mesmo mês.


--Quais são os produtos que têm a segunda maior venda em cada categoria? Use funções analíticas.


--Calcule o valor acumulado dos pedidos para cada cliente, ordenando por data de pedido.


--Liste os produtos que foram comprados por mais de 3 clientes diferentes em fevereiro de 2023.


--Mostre todos os pedidos que foram processados em menos de 24 horas após a realização do pedido.


--Encontre os clientes que fizeram pedidos que totalizaram mais de R$ 5000,00 em menos de 30 dias.







