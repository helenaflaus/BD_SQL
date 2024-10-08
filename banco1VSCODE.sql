-- Active: 1716856021564@@127.0.0.1@5432@bancoguardado1405
-- BD cinema
SET DATESTYLE TO POSTGRES, DMY ;
/* tabela sala de exibição
*/
DROP TABLE IF EXISTS sala CASCADE;
CREATE TABLE sala (
nome_sala CHAR(15) PRIMARY KEY,
capac_sala SMALLINT NOT NULL,
tipo_audio CHAR(15) NOT NULL,
tipo_video CHAR(15) NOT NULL,
situacao_sala CHAR(15) NOT NULL 
CHECK (situacao_sala
IN ( 'ATIVA', 'INATIVA','MANUTENCAO')) ) ;
-- populando sala
INSERT INTO sala VALUES ('Scorsese', 150, 
     'Dolby Surround', '4D Miramax', 'ATIVA') ;
INSERT INTO sala ( situacao_sala, nome_sala,
tipo_video, capac_sala, tipo_audio)
VALUES ( 'MANUTENCAO', 'Coppola', '2D', 200,'Dolby');
-- verificando 
SELECT * FROM sala ;
-- tabela sessao
DROP TABLE IF EXISTS sessao CASCADE;
CREATE TABLE sessao (
num_sessao SERIAL PRIMARY KEY ,
dt_sessao DATE NOT NULL,
publico SMALLINT,
renda_sessao NUMERIC(10,2) NOT NULL,
legendado BOOLEAN NOT NULL,
idioma_sessao CHAR(15) NOT NULL,
nome_sala CHAR(15) NOT NULL,
FOREIGN KEY (nome_sala) REFERENCES sala(nome_sala)
ON DELETE RESTRICT ON UPDATE CASCADE) ;
-- populando sessao
INSERT INTO sessao VALUES ( default, 
current_date, 0, 0, 'T',
'Ingles', 'Coppola');
-- tabela filme
DROP TABLE IF EXISTS filme CASCADE ;
CREATE TABLE filme (
cod_filme SMALLINT NOT NULL,
titulo_original VARCHAR(35) NOT NULL,
titulo_portugues VARCHAR(35) NOT NULL,
idioma_original CHAR(15) NOT NULL,
sinopse VARCHAR(100) NOT NULL,
duracao_min SMALLINT NOT NULL,
ano_lancamento SMALLINT NOT NULL,
situacao_filme CHAR(15) NOT NULL) ;
-- adicionando CONSTRAINTS
-- PK
ALTER TABLE filme ADD CONSTRAINT filme_pk PRIMARY KEY(cod_filme) ;
-- check em situação
ALTER TABLE filme 
ADD CHECK (situacao_filme IN ('EM CARTAZ','FORA CARTAZ','SEM COPIA'));
-- tabela horario
DROP TABLE IF EXISTS horario CASCADE ;
CREATE TABLE horario (
cod_horario SMALLINT PRIMARY KEY,
hora TIME NOT NULL ) ;
-- populando horario
INSERT INTO horario VALUES (14, '14:00:00');
INSERT INTO horario VALUES (20, '20:00:00');
-- populando filme
INSERT INTO filme VALUES ( 1, 'Madagascar III', 'Madagascar III',
'INGLES', 'Nova aventura dos animais em Madagascar'	, 119, 2012,
'EM CARTAZ' );
INSERT INTO filme VALUES ( 2, 'Terra em transe', 'Terra em transe',
'PORTUGUES', 'Distopia sobre a realidade brasileira', 109, 1967,
'EM CARTAZ' );
-- adicionando as FKs de horario e filme na sessao
ALTER TABLE sessao ADD COLUMN cod_horario SMALLINT NULL; 
ALTER TABLE sessao ADD CONSTRAINT fk_horario 
FOREIGN KEY (cod_horario) REFERENCES horario (cod_horario)
ON DELETE CASCADE ON UPDATE CASCADE ;
SELECT * FROM Sessao ;
UPDATE sessao
SET cod_horario = 14, publico = 10
WHERE num_sessao = 2 ;
-- testando a integridade referencial
SELECT * FROM horario ;
DELETE FROM horario WHERE cod_horario = 14 ;
-- atualizacao em cascata
UPDATE horario
SET cod_horario = 16, hora = '16:00:00'
WHERE cod_horario = 14 ;
-- alterar a FK horario em sessao para not null
ALTER TABLE sessao ALTER COLUMN cod_horario SET NOT NULL ;
-- adicionando a FK de filme em sessao
ALTER TABLE sessao ADD COLUMN cod_filme SMALLINT NULL ;
ALTER TABLE sessao ADD CONSTRAINT chave_estrangeira_filme_na_sessao
FOREIGN KEY (cod_filme) REFERENCES filme
ON DELETE RESTRICT ON UPDATE SET NULL ;
-- nova sessao 
INSERT INTO sessao VALUES ( default, 
current_date + 3, 0, 0, 'T','Portugues', 'Scorsese', 16, 1) ;
SELECT * FROM sessao ;
-- atualizando filme
SELECT * FROM filme ;
UPDATE filme SET cod_filme = 11 WHERE cod_filme = 1 ;
UPDATE sessao SET cod_filme = 11 WHERE num_sessao = 2 ;
-- tentando deletar o filme 11
DELETE FROM filme WHERE cod_filme = 11;
-- novo filme que não existe
INSERT INTO filme VALUES ( 9999, 'Nada existe tudo passara',
'Nada existe tudo passara', 'PORTUGUES', 
'Distopia utopica sobre o niilismo', 300, 2024,'EM CARTAZ' );
UPDATE sessao SET cod_filme = 9999 WHERE num_sessao = 2 ;
-- inserindo nova sessao
INSERT INTO sessao VALUES ( default, 
current_date + 3, 0, 0, 'T','Portugues', 'Scorsese', 16, 1) ;
SELECT * FROM sessao ;
-- atualizando a sessao 3 com filme e alterando para not null
UPDATE sessao SET cod_filme = 2 WHERE num_sessao = 3 ;
ALTER TABLE sessao ALTER COLUMN cod_filme SET NOT NULL ;
-- alterando a definicao da constraint
ALTER TABLE sessao DROP CONSTRAINT chave_estrangeira_filme_na_sessao;
ALTER TABLE sessao ADD CONSTRAINT chave_estrangeira_filme_na_sessao
FOREIGN KEY (cod_filme) REFERENCES filme
ON DELETE RESTRICT ON UPDATE CASCADE ;
-- conferindo
SELECT * FROM filme ;
SELECT * FROM sessao ;
SELECT * FROM horario ;
-- alterar a estrutura de algumas tabelas
-- adicionar coluna e mudar o tipo de dado
ALTER TABLE filme ADD COLUMN genero VARCHAR(20) NULL,
ADD COLUMN class_etaria CHAR(20) NULL;
-- mudando o tipo de dado
ALTER TABLE filme ALTER COLUMN genero TYPE CHAR(20) ;
ALTER TABLE filme ALTER COLUMN class_etaria TYPE VARCHAR(20) ;
DESCRIBE filme ;
-- atribuir um valor default para uma coluna
ALTER TABLE sessao ALTER COLUMN dt_sessao SET DEFAULT current_date;

-- verifica a estrutura da tabela
SELECT table_name AS "nome tabela", column_name AS "nome coluna" , 
data_type AS "tipo dado", is_nullable "Permite nulo"
FROM information_schema.columns
WHERE table_name = 'filme' ;

SELECT * FROM information_schema.columns
WHERE table_name = 'filme' ;

SELECT * FROM horario ;

/**** Atividade 3 ****
1- Montar o script em SQL para a criação das tabelas EM VERDE no SGBD Postgresql tomando como base o esquema de relações e o diagrama lógico-relacional, com as seguintes características : 
a) Considere as seguintes auto numerações :
	a1) Número do funcionário.
b) Ações referenciais ON DELETE ON UPDATE
c) Colunas que indicam instante de tempo com o tipo de dado correspondente (DATE ou TIMESTAMP).  */

INSERT INTO horario VALUES (14, '14:00:00');
-- tabela Funcionário  - Funcionario (Cod_func(PK), Nome_func, sexo_func [M,F], Dt_nascto, Dt_admissao, Salario, Num_CTPS(unique), Situacao_func)
DROP TABLE IF EXISTS funcionario CASCADE ;
CREATE TABLE funcionario
( cod_funcional SERIAL PRIMARY KEY ,
nome_func VARCHAR(50) NOT NULL,
sexo_func CHAR(1) NOT NULL CHECK ( sexo_func IN ('M', 'F')),
dt_nascto_func DATE NOT NULL,
dt_admissao DATE NOT NULL,
salario NUMERIC(10,2),
num_ctps INTEGER NOT NULL,
situacao_func CHAR(15) NOT NULL,
UNIQUE(num_ctps));

-- funcionário
INSERT INTO funcionario VALUES (default, 'Jose de Arimateia','M', '10/10/1990', current_date - 1500, 3500.00, 123456, 'EM ATIVIDADE') ;
INSERT INTO funcionario VALUES ( default, 'Maria Conceicao dos Santos','F', '15/12/1988', current_date - 1300, 4000.00, 987654, 'EM ATIVIDADE') ;
INSERT INTO funcionario VALUES ( default, 'Tereza Baptista Silva','F', '05/02/1998', '10/01/2019', 3750.00, 658734, 'EM ATIVIDADE') ;
INSERT INTO funcionario VALUES ( default, 'Joao de Castro e Souza','M', '10/01/1989', current_date - 320, 2755.00, 342176, 'EM ATIVIDADE') ;
SELECT * FROM funcionario ;

-- Escala_Trabalho (Cod_horario(PK)(FK),Cod_func(PK)(FK), dia_semana(PK), Funcao)
-- escala do funcionario
DROP TABLE escala_trabalho CASCADE ;
CREATE TABLE escala_trabalho
( cod_horario INTEGER NOT NULL REFERENCES horario ON DELETE CASCADE ON UPDATE CASCADE,
cod_funcional INTEGER NOT NULL REFERENCES funcionario ON DELETE CASCADE ON UPDATE CASCADE,
dia_semana CHAR(15) NOT NULL,
funcao CHAR(15) NOT NULL,
PRIMARY KEY ( cod_horario, cod_funcional, dia_semana)) ;

INSERT INTO escala_trabalho VALUES ( 14, 1, 'segunda-feira', 'CAIXA') ;
INSERT INTO escala_trabalho VALUES ( 14, 2, 'segunda-feira', 'ATENDENTE') ;
INSERT INTO escala_trabalho VALUES ( 14, 3, 'segunda-feira', 'GERENTE') ;
INSERT INTO escala_trabalho VALUES ( 20, 4, 'terca-feira', 'CAIXA') ;
INSERT INTO escala_trabalho VALUES ( 14, 4, 'segunda-feira', 'CAIXA') ;
INSERT INTO escala_trabalho VALUES ( 14, 3, 'segunda-feira', 'ATENDENTE') ;
INSERT INTO escala_trabalho VALUES ( 14, 2, 'segunda-feira', 'GERENTE') ;
INSERT INTO escala_trabalho VALUES ( 20, 1, 'terca-feira', 'CAIXA') ;
INSERT INTO escala_trabalho VALUES ( 14, 4, 'terca-feira', 'CAIXA') ;
SELECT * FROM escala_trabalho ;

-- Premio (Sigla_premio(PK), nome_premio)
DROP TABLE IF EXISTS premio CASCADE ;
CREATE TABLE premio (
sigla_premio CHAR(6) PRIMARY KEY,
nome_premio VARCHAR(30) NOT NULL ) ;

INSERT INTO premio VALUES ( 'OSCAR', 'Oscar') ;
INSERT INTO premio VALUES ( 'CANNES', 'Festival de Cannes') ;
INSERT INTO premio VALUES ( 'URSO', 'Urso de ouro Festival Berlim') ;
SELECT * FROM premio ;

-- Premiacao ( Sigla_premio(PK)(FK), Cod_filme(PK)(FK), Categoria(PK), Ano_premiacao)
DROP TABLE IF EXISTS premiacao CASCADE ;
CREATE TABLE premiacao (
sigla_premio CHAR(6) NOT NULL REFERENCES premio ON DELETE CASCADE ON UPDATE CASCADE , 
cod_filme SMALLINT NOT NULL REFERENCES filme ON DELETE CASCADE ON UPDATE CASCADE, 
categoria CHAR(15) NOT NULL, 
ano_premiacao SMALLINT NOT NULL,
PRIMARY KEY ( sigla_premio, cod_filme, categoria) ) ;

INSERT INTO premiacao VALUES ( 'CANNES', 2 , 'Melhor Filme', 1968) ;
INSERT INTO premiacao VALUES ( 'URSO', 2 , 'Melhor Filme', 1968) ;
INSERT INTO premiacao VALUES ( 'URSO', 2 , 'Melhor Direcao', 1968) ;
INSERT INTO premiacao VALUES ( 'OSCAR', 1 , 'Melhor Animacao', 2012) ;
INSERT INTO premiacao VALUES ( 'OSCAR', 1 , 'Trilha Sonora', 2012) ;
SELECT * FROM premiacao ;

/* 2- Com o comando ALTER TABLE: 
a) Inclua duas novas colunas em Filme: Estudio e Nacionalidade  */
ALTER TABLE filme ADD COLUMN estudio VARCHAR(20) , ADD COLUMN nacionalidade VARCHAR(15) ;

/* no oracle ou mysql
ALTER TABLE tabela ADD COLUMN (coluna1 INTEGER, coluna2 CHAR(10), ...) ; */

/* b) Crie as seguintes constraints de verificação : 
		Função em Escala-Funcionário: Caixa, Atendente, Gerente
		Situação em Funcionário: Em atividade, Desligado, Afastado  */
ALTER TABLE escala_trabalho ADD CHECK (funcao IN ('CAIXA', 'ATENDENTE', 'GERENTE' )) ;
ALTER TABLE funcionario ADD CHECK (situacao_func IN ('EM ATIVIDADE', 'DESLIGADO', 'AFASTADO' ));
--c) mude o tamanho de alguma coluna
ALTER TABLE premiacao ALTER COLUMN categoria TYPE CHAR(20) ;
--d) renomeie alguma coluna
ALTER TABLE sala RENAME COLUMN capac_sala TO capacidade_sala ;
--e) atribua um valor default para a situação do funcionário
ALTER TABLE funcionario ALTER COLUMN situacao_func SET DEFAULT 'EM ATIVIDADE' ;
-- 3 - Popular as tabelas em verde: insira três linhas em cada tabela
-- realizado em 1 
--4 – Atualize os dados das colunas novas que foram criadas.
UPDATE filme SET estudio = 'Mapa Producoes', nacionalidade = 'Brasil'
WHERE cod_filme = 2 ;
UPDATE filme SET estudio = 'DreamWorks', nacionalidade = 'EUA'
WHERE cod_filme = 1 ;
UPDATE filme SET estudio = 'Coach Divino', nacionalidade = 'PAN'
WHERE cod_filme = 9999 ;
SELECT * FROM filme ;
-- redefinindo para NOT NULL
ALTER TABLE filme ALTER COLUMN estudio SET NOT NULL ;
ALTER TABLE filme ALTER COLUMN nacionalidade SET NOT NULL ;
/**** Aula 07/maio - SELECT com funções caracter e data - JOIN ****/
-- atualizando genero e classificacao etaria
UPDATE filme SET genero = 'Animacao', class_etaria = 'LIVRE' WHERE cod_filme = 1 ;
UPDATE filme SET genero = 'Drama', class_etaria = '16 anos' WHERE cod_filme = 2 ;
UPDATE filme SET genero = 'Misterio', class_etaria = '18 anos' WHERE cod_filme = 9999 ;
-- SELECT
/* estrutura básica de um SELECT
SELECT coluna1, coluna2, ..., colunaN -- colunas para exibir
FROM tabela1, tabela2, ..., tabelaN -- tabelas envolvidas
WHERE condicao1 AND condicao2 OR ... condicaoN; -- filtros */
-- 1 - select + basico, mostra todas as linhas e colunas
SELECT * FROM sessao ;
SELECT * FROM filme ;
-- 2 - discriminando as colunas e colocando condicao
SELECT titulo_original, genero
-- , ano_lancamento
FROM filme 
WHERE ano_lancamento >= 2000 ;
-- 3 - mais de uma condicao
SELECT * FROM filme ;
SELECT titulo_original, genero, idioma_original, class_etaria
FROM filme 
WHERE ano_lancamento >= 2000 AND genero = 'Animacao'
 OR idioma_original = 'INGLES' ;
-- 4 - Funcoes caractere UPPER, LOWER, INITCAP
SELECT UPPER(titulo_original) AS "Titulo do Filme", 
LOWER(genero) AS Genero_minusculo, 
INITCAP(idioma_original) AS "Idioma nativo do Filme",
LOWER( class_etaria) AS Classificacao_etaria
FROM filme 
WHERE ano_lancamento >= 2000
 OR LOWER(idioma_original) = 'portugues' ;
 -- 5 - operador de concatenacao - formatação
SELECT nome_func, dt_nascto_func, salario
FROM funcionario ; 
 -- 5 - operador de concatenacao - formatação
SELECT UPPER(nome_func||' nasceu em '||
TO_CHAR(dt_nascto_func, 'DD/MON/YY')
||' e tem a remuneracao de '||salario) 
AS "Dados Funcionarios"
FROM funcionario ; 
-- 6 - operador LIKE - busca não exata
SELECT UPPER(titulo_original) AS "Titulo do Filme", 
LOWER(genero) AS Genero_minusculo, 
INITCAP(idioma_original) AS "Idioma nativo do Filme",
LOWER( class_etaria) AS Classificacao_etaria
FROM filme 
WHERE UPPER(idioma_original) LIKE '%PORTUG%' ;
-- 7 - funcionarios com silva no nome 
SELECT *
FROM funcionario 
WHERE UPPER(nome_func) LIKE '%SILVA%' ;
-- ultimo nome seja Silva
SELECT *
FROM funcionario 
WHERE UPPER(nome_func) LIKE '%SILVA' ;
-- funcionario jose e silva no sobrenome
SELECT *
FROM funcionario 
WHERE UPPER(nome_func) LIKE '%SILVA' 
AND UPPER(nome_func) LIKE 'JOS_ %' ;
-- funcoes de data
-- 8 - funcoes do sistema 
SELECT current_date AS "Data atual",
current_timestamp AS "Data hora atual",
now() "idem current_timestamp",
localtimestamp AS "Data hora local" ;
-- 9 - operador EXTRACT tira pedaços da data
SELECT EXTRACT(YEAR FROM current_date) AS Ano,
EXTRACT(MONTH FROM current_date) AS Mes,
EXTRACT(DAY FROM current_date) AS Dia,
EXTRACT(WEEK FROM current_date) AS Semana,
EXTRACT (HOUR FROM current_timestamp) AS Hora ;
-- 10-funcionarios que nasceram há mais de 30 anos
SELECT nome_func, dt_nascto_func
FROM funcionario
WHERE EXTRACT(YEAR FROM current_date) - EXTRACT(YEAR FROM dt_nascto_func) >=30 ; 
-- 11 - Operador INTERVAL 
SELECT nome_func, dt_nascto_func
FROM funcionario
WHERE current_date - INTERVAL '30' YEAR >= dt_nascto_func ; 
-- 12 -- funcionarios entre 20 e 25 anos
SELECT nome_func, dt_nascto_func
FROM funcionario
WHERE dt_nascto_func BETWEEN current_date - INTERVAL '35' YEAR
                             AND current_date - INTERVAL '20' YEAR ;
-- 13 - intervalo sessões							 
SELECT * FROM sessao ;
ALTER TABLE sessao ADD COLUMN hora_inicio TIME ;
-- UPDATE sessao SET hora_inicio = 
-- CAST(EXTRACT(HOUR FROM (SELECT now() + INTERVAL '3' MINUTE)) AS TIME) ;
UPDATE sessao SET hora_inicio = '16:00:00'  WHERE num_sessao = 2;
UPDATE sessao SET hora_inicio = '16:05:00'  WHERE num_sessao != 2;
SELECT ss.hora_inicio
FROM sessao ss
WHERE ss.hora_inicio BETWEEN '15:55:00' - INTERVAL '10' MINUTE AND '16:08:00' ;
-- 14 - interval de dia minutos e segundos
SELECT current_timestamp AS Data_hora_atual,
current_timestamp + INTERVAL '20' DAY - INTERVAL '78' MINUTE 
+ INTERVAL '100' SECOND ;
-- 15 - lembrando da nossa P2
SELECT current_date + INTERVAL '35' DAY AS "P2",
current_date + 35 AS "P2_novo" ;
-- 16 - calculo da idade
SELECT (current_date - dt_nascto_func)*24*60*60 AS "Segundos de Existencia",
TRUNC((current_date - dt_nascto_func)/365.25) AS Idade,
ROUND((current_date - dt_nascto_func)/365.25, 2) AS Idade_precisa
FROM funcionario ;
-- 17 - Conversao de data para char
SELECT TO_CHAR(f.dt_nascto_func, 'DD/MON/YYYY') AS Data_Nascto,
TO_TIMESTAMP('07/05/2024','DD/MM/YYYY H24:MM:SS') AS Data_hoje
FROM funcionario f;
-- 18 - conversao de string para numero TO_CHAR
SELECT TO_CHAR(3.141596, '0099.99999999') ;
-- 19 - conversao para numero
SELECT TO_NUMBER('3,141596', '9E000' ) ;

/* Atividade 04 : 
1– Mostrar os dados dos filmes do gênero Drama no formato :
‘Guerra nas Estrelas foi lançado em 1977 com classificação etária LIVRE’ */
SELECT RTRIM(titulo_original)||' foi lançado em '|| ano_lancamento||
' com classificacao etária '||class_etaria
AS "Dados principais Filme "
FROM filme
WHERE UPPER(genero) LIKE '%DRAMA%' ;

/* 2- Mostrar o título original, estúdio e ano de lançamento dos filmes
que tem ‘GUERRA’ ou ‘BATALHA’ no nome  e duram mais de 140 minutos */
SELECT * FROM filme ;
INSERT INTO filme VALUES ( 3, 'Star Wars', 'Guerra nas Estrelas',
'INGLES', 'Guerra no espaço sideral', 119, 1977,
'EM CARTAZ', 'Ficcao', 'LIVRE', 'Lucas Films', 'EUA' );
SELECT f.titulo_portugues, f.estudio, f.ano_lancamento, f.duracao_min
FROM filme f
WHERE f.duracao_min >= 100
AND (LOWER(f.titulo_portugues) LIKE '%guerra%' 
	 OR LOWER(f.titulo_portugues) LIKE '%batalha%')  ;

/* 3– Mostrar os dados dos funcionários mulheres que tem mais de 22 anos :
Nome Funcionário-Idade */
SELECT f.nome_func, ROUND(( current_date - f.dt_nascto_func)/365.25, 1) AS Idade
FROM funcionario f
WHERE f.sexo_func = 'F' 
AND f.dt_nascto_func <= current_date - INTERVAL '22' YEAR ;

/* 4- Mostrar as sessões de cinema exibidas este ano que não tem 
som do tipo Surround: 
Número da Sessão – Data Sessão – Tipo Áudio */ 
SELECT s.num_sessao, s.dt_sessao, sa.tipo_audio
FROM sessao s JOIN sala sa
ON (s.nome_sala = sa.nome_sala  )
WHERE UPPER(sa.tipo_audio) NOT LIKE '%SURROUND%'
AND EXTRACT(YEAR FROM s.dt_sessao ) = EXTRACT(YEAR FROM current_date) ;

/** Aula 14/maio/24 - Junção com mais de 2 tabelas **/
-- 20 - Mostrar a premiação dos filmes : premio, premiacao, filme
SELECT f.titulo_original AS Titulo, p.nome_premio AS Premio,
pr.categoria AS Categoria, pr.ano_premiacao AS Ano
FROM filme f JOIN premiacao pr ON (f.cod_filme = pr.cod_filme )
             JOIN premio p ON (pr.sigla_premio = p.sigla_premio)
WHERE f.ano_lancamento BETWEEN 1950 AND 2024 ;
-- 21 - Sintaxe no WHERE Mostrar a premiação dos filmes : premio, premiacao, filme
SELECT f.titulo_original AS Titulo, p.nome_premio AS Premio,
pr.categoria AS Categoria, pr.ano_premiacao AS Ano
FROM filme f , premiacao pr, premio p
WHERE f.cod_filme = pr.cod_filme -- junção de filme x premiacao
AND pr.sigla_premio = p.sigla_premio -- junção de premiacao x premio
AND f.ano_lancamento BETWEEN 1950 AND 2024 ; -- filtro
-- 22 - Lista dos filmes exibidos : sessao, filme, sala, horario
SELECT ss.num_sessao, ss.dt_sessao, h.hora AS Horario, f.titulo_original,
ss.legendado AS Legendado, s.nome_sala, s.capacidade_sala, f.genero
FROM filme f JOIN sessao ss ON ( f.cod_filme = ss.cod_filme)
             JOIN sala s ON (s.nome_sala = ss.nome_sala )
			 JOIN horario h ON (h.cod_horario = ss.cod_horario)
WHERE ss.dt_sessao >= now() - INTERVAL '12' DAY
AND UPPER(f.genero) NOT IN ('DRAMA', 'ROMANCE')
ORDER BY 1 ;
SELECT UPPER('to pequenininho') AS "Mas virei GRANDÃO";
-- 23 - Lista dos filmes exibidos : sessao, filme, sala, horario
-- e quem trabalha em cada horario, e o que faz, onde vive, como se alimenta e procria
SELECT ss.num_sessao, ss.dt_sessao, h.hora AS Horario, f.titulo_original,
ss.legendado AS Legendado, s.nome_sala, s.capacidade_sala, f.genero,
func.nome_func AS Funcionario, et.funcao AS "Funcao no horario",
f.class_etaria AS "Classificação ETária"
FROM filme f JOIN sessao ss ON ( f.cod_filme = ss.cod_filme)
             JOIN sala s ON (s.nome_sala = ss.nome_sala ) 
			 JOIN horario h ON (h.cod_horario = ss.cod_horario)
             JOIN escala_trabalho et ON (h.cod_horario = et.cod_horario)
             JOIN funcionario func ON (func.cod_funcional = et.cod_funcional)
WHERE s.capacidade_sala >= 100 AND ( func.sexo_func != 'M' OR 
	                                 func.sexo_func != 'F' )								
AND UPPER(f.class_etaria) NOT LIKE '%18%'
ORDER BY 6, 1 ;
-- 24 - Lista dos filmes exibidos : sessao, filme, sala, horario
-- e quem trabalha em cada horario, e o que faz, onde vive, como se alimenta e procria
-- e os premios de cada filme
SELECT ss.num_sessao, ss.dt_sessao, h.hora AS Horario, f.titulo_original,
ss.legendado AS Legendado, s.nome_sala, s.capacidade_sala, f.genero,
func.nome_func AS Funcionario, et.funcao AS "Funcao no horario",
TRUNC((current_date - func.dt_admissao)/365.25,2) AS Anos_Trabalho,
f.class_etaria AS "Classificação ETária", p.nome_premio AS Premio,
pr.categoria AS Categoria, pr.ano_premiacao AS Ano
FROM filme f JOIN sessao ss ON ( f.cod_filme = ss.cod_filme)
    JOIN sala s ON (s.nome_sala = ss.nome_sala ) 
	JOIN horario h ON (h.cod_horario = ss.cod_horario)
    JOIN escala_trabalho et ON (h.cod_horario = et.cod_horario)
    JOIN funcionario func ON (func.cod_funcional = et.cod_funcional)
    JOIN premiacao pr ON (f.cod_filme = pr.cod_filme )
    JOIN premio p ON (pr.sigla_premio = p.sigla_premio)
ORDER BY Anos_Trabalho ;
/*** Funções de grupo ***
COUNT, MAX, MIN, AVG, SUM ***/
-- 25 -- todas as funcoes
UPDATE sessao SET publico = 100 + 2*num_sessao,
renda_sessao = 5000*(SQRT(num_sessao)) ;
SELECT * FROM sessao ;
SELECT COUNT(*) AS "Qtas sessoes",
       MAX(renda_sessao) AS "Maior Renda",
	   MIN(renda_sessao) AS "Menor Renda",
	   AVG(renda_sessao) AS "Media Renda",
	   SUM(renda_sessao) AS "Total arrecadado"
FROM sessao ;
-- 26 - clausula GROUP BY - agrupado por 
SELECT * FROM sessao ;
INSERT INTO sessao VALUES ( default, 
current_date - 5, 144, 12534.99, 'F','Portugues', 'Scorsese', 14, 3, '14:03:00') ;
INSERT INTO sessao VALUES ( default, 
current_date - 5, 174, 13534.99, 'T','Portugues', 'Scorsese', 20, 3, '20:03:00') ;
INSERT INTO sessao VALUES ( default, 
current_date - 1, 124, 8565.99, 'T','Portugues', 'Coppola', 20, 1, '20:03:00') ;
INSERT INTO sessao VALUES ( default, 
current_date - 125, 133, 10534.99, 'F','Portugues', 'Scorsese', 14, 3, '14:03:00') ;

-- renda por filme
SELECT f.titulo_original AS Titulo, SUM(ss.renda_sessao) AS Total,
COUNT(ss.num_sessao) AS "Qtas Sessoes"
FROM filme f JOIN sessao ss ON (f.cod_filme = ss.cod_filme)
--WHERE f.cod_filme = ss.cod_filme
GROUP BY f.titulo_original
ORDER BY Total DESC ;
UPDATE sessao SET dt_sessao = dt_sessao - 5 ;
-- 27 - por tipo de audio e por mês
SELECT EXTRACT(MONTH FROM ss.dt_sessao) AS Mes_Exibicao,
s.tipo_audio AS Tipo_Audio,
SUM(ss.publico) AS Publico_Total, COUNT(*) AS NUmero_sessoes,
AVG(ss.publico) AS Media 
FROM sessao ss JOIN sala s ON (s.nome_sala = ss.nome_sala)
GROUP BY Mes_Exibicao, Tipo_Audio
ORDER BY Mes_Exibicao ; 
-- 28 - filtro 
SELECT f.titulo_original AS Titulo, SUM(ss.renda_sessao) AS Total,
COUNT(ss.num_sessao) AS "Qtas Sessoes"
FROM filme f JOIN sessao ss ON (f.cod_filme = ss.cod_filme)
WHERE EXTRACT(YEAR FROM ss.dt_sessao) = 2024
GROUP BY f.titulo_original
HAVING SUM(ss.renda_sessao) >= 10000 
ORDER BY Total DESC ;
-- Regras - WHERE sempre antes de GROUP BY, HAVING sempre depois
-- Ao lado do HAVING só função de grupo, no WHERE nunca função de grupo
-- Regras - WHERE sempre antes de GROUP BY, HAVING sempre depois
-- Ao lado do HAVING só função de grupo, no WHERE nunca função de grupo
-- 29 - qtde de premios do filme por categoria
SELECT f.titulo_original AS Filme,
pr.categoria AS Categoria, COUNT(pr.cod_filme) AS Qtde_Categoria
FROM filme f , premiacao pr, premio p
WHERE f.cod_filme = pr.cod_filme -- junção de filme x premiacao
AND pr.sigla_premio = p.sigla_premio -- junção de premiacao x premio
AND f.ano_lancamento BETWEEN 1950 AND 2024
GROUP BY f.titulo_original, pr.categoria
ORDER BY 1 ;
-- 30 - qtde de premios do filme por genero
SELECT f.genero AS Filme,
COUNT(pr.cod_filme) AS Qtde_Premios
FROM filme f , premiacao pr, premio p
WHERE f.cod_filme = pr.cod_filme -- junção de filme x premiacao
AND pr.sigla_premio = p.sigla_premio -- junção de premiacao x premio
AND f.ano_lancamento BETWEEN 1950 AND 2024
GROUP BY f.genero
ORDER BY 1 ;
-- 31 - melhor taxa de ocupacao por filme
SELECT f.titulo_original AS Titulo, 
AVG(ss.publico*100/s.capacidade_sala) AS Media_Ocupacao,
COUNT(ss.num_sessao) AS "Qtas Sessoes"
FROM filme f JOIN sessao ss ON (f.cod_filme = ss.cod_filme)
JOIN sala s ON (s.nome_sala = ss.nome_sala)
GROUP BY f.titulo_original
HAVING AVG(ss.publico*100/s.capacidade_sala) > 60
ORDER BY Media_Ocupacao DESC ;

SELECT * FROM sessao ;
SELECT ss.publico, s.capacidade_sala, (ss.publico*100/s.capacidade_sala)
FROM sessao ss JOIN sala s ON (s.nome_sala = ss.nome_sala)

/* Atividade 05 – Utilizando o comando SELECT do SQL: 
1-	Mostrar as sessões em que trabalharam funcionários do sexo Masculino, 
admitidos há mais de 1 ano e não tiveram função de Gerente: 
Número da sessão – Data Sessão – Nome Funcionário – Tempo de casa - Função */
SELECT ss.num_sessao, ss.dt_sessao, f.nome_func AS Funcionario,
h.hora,
ROUND(( current_date - f.dt_admissao)/365.25, 1) AS Tempo_Casa_Anos,
et.funcao AS "Funcao no horario" 
FROM sessao ss JOIN horario h ON (h.cod_horario = ss.cod_horario)
             JOIN escala_trabalho et ON (h.cod_horario = et.cod_horario)
             JOIN funcionario f ON (f.cod_funcional = et.cod_funcional)
WHERE f.sexo_func = 'M'
AND et.funcao NOT LIKE '%GEREN%'
AND f.dt_admissao <= current_date - INTERVAL '1' YEAR
ORDER BY 5 DESC, 1 ;

SELECT * FROM escala_trabalho ;

/* 2-	Mostrar os filmes brasileiros que tiveram premiação – não no Oscar – 
exibidos em sessões noturnas (acima das 18 h) com ocupação da sala superior a 75%:
Título Filme – Número da sessão – Horário – Publico – Capacidade da Sala – Taxa de Ocupação*/
SELECT f.titulo_original, ss.num_sessao, h.hora AS Horario, 
ss.publico, s.capacidade_sala, 
TRUNC((ss.publico::NUMERIC/s.capacidade_sala::NUMERIC)*100,0) As Taxa,
p.nome_premio, pr.categoria
FROM filme f JOIN sessao ss ON ( f.cod_filme = ss.cod_filme)
    JOIN sala s ON (s.nome_sala = ss.nome_sala ) 
	JOIN horario h ON (h.cod_horario = ss.cod_horario)
    JOIN premiacao pr ON (f.cod_filme = pr.cod_filme )
    JOIN premio p ON (pr.sigla_premio = p.sigla_premio)
WHERE UPPER(p.nome_premio) NOT LIKE '%OSCAR%'
AND UPPER(f.nacionalidade) LIKE '%BRA_IL%'
AND h.hora > '18:00:00' 
AND TRUNC((ss.publico::NUMERIC/s.capacidade_sala::NUMERIC)*100,0) > 75 ;

/* 3-Mostrar as sessões dos três primeiros meses do ano em que foram exibidos
filmes de Suspense, Drama ou Terror, produzidos fora dos EUA
em salas com tipo de vídeo 3D: 
Número da sessão – Data Sessão – Horário- Título Filme – 
Nacionalidade Filme – Sala – Tipo Áudio – Tipo Vídeo – Público – Renda Total,
ordenado pela data da sessão e horário do mais recente para o mais antigo. */
SELECT ss.num_sessao, ss.dt_sessao, h.hora AS Horario, f.titulo_original,
f.nacionalidade, s.nome_sala, s.tipo_audio AS Audio, s.tipo_video AS Video,
ss.publico , ss.renda_sessao,  f.genero
FROM filme f JOIN sessao ss ON ( f.cod_filme = ss.cod_filme)
    JOIN sala s ON (s.nome_sala = ss.nome_sala ) 
	JOIN horario h ON (h.cod_horario = ss.cod_horario)
WHERE EXTRACT(MONTH FROM ss.dt_sessao) IN (1,2,3)
AND UPPER(f.genero) IN ('SUSPENSE', 'DRAMA', 'TERROR')
AND f.nacionalidade <> 'EUA'
AND UPPER(s.tipo_video) NOT LIKE '%3D%'
ORDER BY 2 DESC, Horario DESC ;

/* 4-Mostrar o valor arrecadado (renda) a cada mês nos últimos 6 meses
por filmes que não sejam do gênero ROMANCE ou COMÉDIA e
que ultrapassem mais de R$ 5 mil de arrecadação total:
Mês – Gênero - Qtde Ingressos – Valor arrecadado */
SELECT EXTRACT(MONTH FROM ss.dt_sessao) AS Mes , f.genero, 
SUM(ss.publico) AS Qtde_Ingressos , 
SUM(ss.renda_sessao) AS Total
FROM filme f JOIN sessao ss ON (f.cod_filme = ss.cod_filme)
WHERE ss.dt_sessao > current_date - INTERVAL '6' MONTH
--AND UPPER(f.genero) NOT IN ('ROMANCE', 'COMEDIA')
AND UPPER(f.genero) NOT LIKE '%ROMANCE%' AND 
UPPER(f.genero) NOT LIKE '%COM_DIA%'
GROUP BY Mes, f.genero
HAVING SUM(ss.renda_sessao) >= 5000 
ORDER BY Mes, Total DESC ;

/* 5-Mostrar a quantidade de sessões exibidas para cada sala,
por mês e por gênero de filme desde que ultrapasse mais de 5 sessões. */
SELECT s.nome_sala AS Sala, EXTRACT(MONTH FROM ss.dt_sessao) AS Mes ,
f.genero, COUNT(ss.num_sessao) AS Qtde_sessoes
FROM filme f JOIN sessao ss ON (f.cod_filme = ss.cod_filme)
             JOIN sala s ON (s.nome_sala = ss.nome_sala ) 
GROUP BY Sala, Mes , f.genero
HAVING COUNT(ss.num_sessao) < 5
ORDER BY 4 DESC ;

/* 6-Mostrar para cada país produtor de filme a quantidade de filmes exibidos,
a renda e público total nos últimos 90 dias desde que o público total
supere 1000 pessoas. */
SELECT f.nacionalidade AS Pais, SUM(ss.publico) AS Qtde_Ingressos , 
SUM(ss.renda_sessao) AS Total, COUNT(f.cod_filme) As Qtos_filmes
FROM filme f JOIN sessao ss ON (f.cod_filme = ss.cod_filme)
WHERE ss.dt_sessao > current_date - 90
GROUP BY f.nacionalidade
HAVING SUM(ss.publico) > 10
ORDER BY 4, 3 DESC ;

/**** Aula 21/maio - Junção Externa - OUTER JOIN - Operador Diferença ***/
-- mais um filme
SELECT * FROM filme ;
INSERT INTO filme VALUES ( 4, 'Cronicas de Narnia', 'Narnia Chronicles',
'INGLES', 'Saindo do armario o Leao te come', 180, 2005,
'EM CARTAZ', 'Fantasia', 'LIVRE', 'Disney', 'EUA');
-- Filmes que tem sessao
SELECT f.cod_filme, f.titulo_original, ss.cod_filme,ss.num_sessao
FROM filme f INNER JOIN sessao ss
    ON ( f.cod_filme = ss.cod_filme) ;
-- Filmes que não tem sessao
SELECT f.cod_filme, f.titulo_original, ss.cod_filme,ss.num_sessao
FROM filme f LEFT OUTER JOIN sessao ss -- (Filme - Sessao)
    ON ( f.cod_filme = ss.cod_filme)
WHERE ss.cod_filme IS NULL ;
-- sessao que não tem filme
SELECT f.cod_filme, f.titulo_original, ss.cod_filme,ss.num_sessao
FROM filme f RIGHT OUTER JOIN sessao ss -- (Sessao - FILME)
    ON ( f.cod_filme = ss.cod_filme)
WHERE f.cod_filme IS NULL ;
-- sessao que não tem filme
SELECT f.cod_filme, f.titulo_original, ss.cod_filme,ss.num_sessao
FROM sessao ss  RIGHT OUTER JOIN filme f -- (FILME - SESSAO)
    ON ( f.cod_filme = ss.cod_filme)
WHERE ss.cod_filme IS NULL ;
-- Diferença usando o operador MINUS
SELECT f.* FROM filme f
WHERE f.cod_filme IN 
( SELECT f.cod_filme -- todos os filmes
FROM filme f
EXCEPT -- MINUS
(SELECT DISTINCT ss.cod_filme -- filmes que tem sessao
 FROM sessao ss )) ;
 -- forma mais intuitiva - NOT IN
SELECT f.* FROM filme f WHERE f.cod_filme NOT IN
 (SELECT DISTINCT ss.cod_filme -- filmes que tem sessao
   FROM sessao ss ) ;
 -- inserindo um novo horario
 INSERT INTO horario VALUES (22, '22:00:00') ;
 -- quais horarios não tem sesoes agendadas
 SELECT f.titulo_original, ss.num_sessao, ss.cod_horario,
 h.cod_horario
FROM sessao ss  INNER JOIN filme f -- (FILME X SESSAO)
    ON ( f.cod_filme = ss.cod_filme)
       RIGHT OUTER JOIN horario h
	ON ( ss.cod_horario = h.cod_horario)
WHERE ss.cod_horario IS NULL ;
-- outra forma usando select aninhado
SELECT h.* , tem_horario.cod_horario
FROM horario h
LEFT OUTER JOIN 
     ( SELECT DISTINCT ss.*
	      FROM sessao ss) tem_horario
ON (h.cod_horario = tem_horario.cod_horario)
WHERE tem_horario.cod_horario IS NULL ;
-- mais um funcionario
INSERT INTO funcionario VALUES 
( default, 'Silvio Santos','M', '10/01/1939', 
 current_date - 1320, 9000.00, 125689, 'EM ATIVIDADE') ;
SELECT * FROM funcionario ;
INSERT INTO funcionario VALUES 
( 5, 'Hebe Camargo','F', '10/01/1949', 
 current_date - 2320, 9700.00, 001, 'EM ATIVIDADE') ;
 -- Mostrar os funcionarios que ainda não foram escalados
 -- para trabalhar nas sessoes
 -- Com outer JOIN
 SELECT f.nome_func , 
 (current_date-f.dt_nascto_func)/365.25 AS Idade,
 f.cod_funcional AS PK_func, et.cod_funcional AS FK_func
 FROM funcionario f LEFT JOIN escala_trabalho et
      ON (f.cod_funcional  = et.cod_funcional )
WHERE et.cod_funcional IS NULL ;
-- outra forma com NOT IN
SELECT f.cod_funcional, f.nome_func -- todos funcionarios
FROM funcionario f
WHERE f.cod_funcional NOT IN 
( SELECT et.cod_funcional 
  FROM escala_trabalho et ) ; -- tem escala trabalho
-- usando EXCEPT (MINUS ou DIFERENÇA)
SELECT * FROM funcionario WHERE cod_funcional IN (
   SELECT f.cod_funcional
     FROM funcionario f
       EXCEPT
        ( SELECT et.cod_funcional 
          FROM escala_trabalho et )) ;
-- Subconsulta ou Subquery ou Select aninhado
-- Sala com maior capacidade de publico
SELECT s.* 
FROM sala s
WHERE s.capacidade_sala = 
      ( SELECT MIN(capacidade_sala) FROM sala)  ;
SELECT s.*
FROM sala
ORDER BY s.capacidade_sala DESC
LIMIT 1 ;
SELECT * FROM filme ;
SELECT 
    sexo_func AS "Nome Funcionario", 
    nome_func AS "Sexo Funcionario"
FROM funcionario ;
SELECT *
FROM funcionario
LIMIT 3 ;
SELECT *
FROM funcionario
ORDER BY salario ;

-- LEFT JOIN 
SELECT 
    sl.nome_sala,  
    sl.tipo_audio, 
    sl.capacidade_sala
WHERE sl.nome_sala NOT IN
    ( SELECT ss.nome_sala FROM sala s JOIN sessao SS -- sala que exibiram Eua
            ON (s.nome_sala = ss.nome_sala )
        JOIN filme f
            ON (s.cod_filme = ss.cod_filme)
        WHERE (f.genero ILIKE '%a__a%' OR f.genero ILIKE '%aventura%')
        AND f.nacionalidade = 'EUA'
        AND ss.legendado ) sala_acao_eua
    ON 
    