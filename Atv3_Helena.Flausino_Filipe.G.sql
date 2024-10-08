-- BD cinema
SET DATESTYLE TO POSTGRES, DMY ;
/* tabela sala de exibição */
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
INSERT INTO sala VALUES ('Scorsese', 150, 'Dolby Surround', '4D Miramax', 'ATIVA') ;
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
INSERT INTO sessao VALUES ( default, current_date, 0, 0,'T','Ingles','Coppola') ;

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
INSERT INTO horario VALUES (14, '14:00:00') ;
INSERT INTO horario VALUES (20, '20:00:00') ;
-- populando filme
INSERT INTO filme VALUES ( 1, 'Madagascar III', 'Madagascar III',
'INGLES', 'Nova aventura dos animais em Madagascar'	, 119, 2012,
'EM CARTAZ' ) ;
INSERT INTO filme VALUES ( 2, 'Terra em transe', 'Terra em transe',
'PORTUGUES', 'Distopia sobre a realidade brasileira', 109, 1967,
'EM CARTAZ' ) ;
-- adicionando as FKs de horario e filme na sessao
ALTER TABLE sessao ADD COLUMN cod_horario SMALLINT NULL ; 
ALTER TABLE sessao ADD CONSTRAINT fk_horario 
FOREIGN KEY (cod_horario) REFERENCES horario (cod_horario)
ON DELETE CASCADE ON UPDATE CASCADE ;
SELECT * FROM Sessao ;
-- atualizando sessao
UPDATE sessao
SET cod_horario = 14, publico = 10
WHERE num_sessao = 1 ;
-- alterar a FK horario em sessao para not null
ALTER TABLE sessao ALTER COLUMN cod_horario SET NOT NULL ;
-- adicionando a FK de filme em sessao
ALTER TABLE sessao ADD COLUMN cod_filme SMALLINT NULL ;
ALTER TABLE sessao ADD CONSTRAINT chave_estrangeira_filme_na_sessao
FOREIGN KEY (cod_filme) REFERENCES filme
ON DELETE RESTRICT ON UPDATE CASCADE ;
-- mais um horário
INSERT INTO horario VALUES (16, '16:00:00') ;
-- nova sessao 
INSERT INTO sessao VALUES ( default, 
current_date + 3, 0, 0, 'T','Portugues', 'Scorsese', 16, 1) ;
UPDATE sessao SET cod_filme = 2 WHERE num_sessao = 1 ;
-- alterando para not null
ALTER TABLE sessao ALTER COLUMN cod_filme SET NOT NULL ;
-- alterar a estrutura de algumas tabelas
-- adicionar coluna e mudar o tipo de dado
ALTER TABLE filme ADD COLUMN genero VARCHAR(20) NULL,
ADD COLUMN class_etaria CHAR(20) NULL;
-- mudando o tipo de dado
ALTER TABLE filme ALTER COLUMN genero TYPE CHAR(20) ;
ALTER TABLE filme ALTER COLUMN class_etaria TYPE VARCHAR(20) ;
-- atribuir um valor default para uma coluna
ALTER TABLE sessao ALTER COLUMN dt_sessao SET DEFAULT current_date;
-- atualizando filme
UPDATE filme SET genero = 'Drama', class_etaria = '16 anos'
WHERE cod_filme = 2 ;
UPDATE filme SET genero = 'Animacao', class_etaria = 'Livre'
WHERE cod_filme = 1 ;

-- conferindo
SELECT * FROM filme ;
SELECT * FROM sessao ;
SELECT * FROM horario ;
-- verifica a estrutura da tabela
SELECT table_name AS "nome tabela", column_name AS "nome coluna" , 
data_type AS "tipo dado", is_nullable "Permite nulo"
FROM information_schema.columns
WHERE table_name = 'filme' ;

SELECT * FROM information_schema.columns
WHERE table_name = 'filme' ;

-- remove a tabela funcionario se ela existir, incluindo dependências em cascata
DROP TABLE IF EXISTS funcionario CASCADE ;
-- criando a tabela funcionario
CREATE TABLE funcionario (
cod_func SERIAL PRIMARY KEY,
nome_func VARCHAR(30) NOT NULL,
sexo_func CHAR(1) CHECK (Sexo_func IN ('M', 'F')),
dt_nascto DATE NOT NULL,
dt_admissao DATE NOT NULL,
salario NUMERIC(10, 2) NOT NULL,
num_CTPS VARCHAR(20) UNIQUE NOT NULL,
situacao_func CHAR(20) NOT NULL
) ;

-- remove a tabela escala_trabalho se ela existir, incluindo dependências em cascata
DROP TABLE IF EXISTS escala_trabalho CASCADE ;
-- criando a tabela escala_trabalho
CREATE TABLE escala_trabalho (
dia_semana CHAR(10),
cod_horario SMALLINT,
cod_func SERIAL,
PRIMARY KEY (dia_semana, cod_horario, cod_func), -- chave primária composta
FOREIGN KEY (cod_horario) REFERENCES horario(cod_horario) 
ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (cod_func) REFERENCES funcionario(cod_func)
ON DELETE RESTRICT ON UPDATE CASCADE,
funcao CHAR(10) NOT NULL
) ;

-- remove a tabela premio se ela existir, incluindo dependências em cascata
DROP TABLE IF EXISTS premio CASCADE;
-- criando a tabela premio
CREATE TABLE premio (
sigla_premio CHAR(6) PRIMARY KEY,
nome_premio VARCHAR(30) NOT NULL
) ;

-- remove a tabela premiacao se ela existir, incluindo dependências em cascata
DROP TABLE IF EXISTS premiacao CASCADE;
-- criando a tabela premiacao
CREATE TABLE premiacao (
sigla_premio CHAR(6),
cod_filme SMALLINT NOT NULL,
categoria CHAR(30) NOT NULL,
PRIMARY KEY (sigla_premio, cod_filme, categoria),
FOREIGN KEY (sigla_premio) REFERENCES premio(sigla_premio) 
ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (cod_filme) REFERENCES filme(cod_filme) 
ON DELETE RESTRICT ON UPDATE CASCADE,
ano_premiacao INTEGER NOT NULL
) ;

-- 2 novas colunas em filme
ALTER TABLE filme ADD COLUMN estudio CHAR(20) ;
ALTER TABLE filme ADD COLUMN nacionalidade CHAR(20) ;

-- constraint de verificação em escala_trabalho
ALTER TABLE escala_trabalho ADD CONSTRAINT check_funcao
CHECK (funcao IN ('Caixa', 'Atendente', 'Gerente')) ;
-- constraint de verificação em funcionario
ALTER TABLE funcionario ADD CONSTRAINT check_situacao_func 
CHECK (situacao_func IN ('Em atividade', 'Desligado', 'Afastado')) ;

-- mudando o tamanho de alguma coluna
ALTER TABLE funcionario
ALTER COLUMN nome_func TYPE VARCHAR(35) ;

-- renomeando uma coluna
ALTER TABLE funcionario
RENAME COLUMN nome_func TO nome_funcionario ;

-- atribuindo um valor default para a situação do funcionário
ALTER TABLE funcionario ALTER COLUMN situacao_func SET DEFAULT 'Em atividade' ;

-- popular a tabela funcionario
INSERT INTO funcionario (nome_funcionario, sexo_func, dt_nascto, dt_admissao, salario, num_CTPS, situacao_func) VALUES
( 'Ana Silva', 'F', '12/04/2003', '15/01/2020', 3500, '001234567', 'Em atividade' ),
( 'João Martins', 'M', '02/07/1990', '01/08/2018', 4200, '002345678', 'Desligado' ),
( 'Luisa Fernandes', 'F', '15/09/2003', '20/05/2019', 5000, '003456789', 'Afastado' ) ;
-- conferindo
SELECT * FROM funcionario ;

--conferindo horario
SELECT * FROM horario ;
-- popular a tabela escala_trabalho
INSERT INTO escala_trabalho (dia_semana, cod_horario, funcao) VALUES
( 'Segunda', 14, 'Atendente' ),
( 'Quarta', 20, 'Caixa' ),
( 'Sexta', 16, 'Gerente' ) ;
-- conferindo
SELECT * FROM escala_trabalho ;

-- popular a tabela premio
INSERT INTO premio VALUES
( 'OSCAR', 'Academy Award of Merit' ),
( 'BAFTA', 'British Academy Awards' ),
( 'CANNES', 'Festival de Cannes' ) 
;
-- conferindo
SELECT * FROM premio ;

--conferindo filme e premio
SELECT * FROM filme ;
-- popular a tabela premiação
INSERT INTO filme VALUES ( 3, 'Barbie', 'Barbie',
'INGLES', 'Da fantasia para a mundo real', 130, 2023,
'EM CARTAZ', 'Drama', 'Livre' ) ;

-- popular premiacao
INSERT INTO premiacao VALUES ( 'OSCAR', 1, 'Melhor animação', 2012 ),
( 'BAFTA', 2, 'Melhor filme', 1968 ),
( 'CANNES', 3, 'Melhor roteiro', 2024 ) ; 
SELECT * FROM premiacao ;

-- atualizando os dados das colunas novas que foram criadas em filme: Estudio e Nacionalidade
UPDATE filme
SET estudio = 'Disney'
WHERE cod_filme = 1 ;
UPDATE filme
SET estudio = 'Tupi'
WHERE cod_filme = 2 ;
UPDATE filme
SET estudio = 'Disney'
WHERE cod_filme = 3 ;
UPDATE filme
SET nacionalidade = 'Estados Unidos'
WHERE cod_filme = 1 ;
UPDATE filme
SET nacionalidade = 'Estados Unidos'
WHERE cod_filme = 3 ;
UPDATE filme
SET nacionalidade = 'Brasil'
WHERE cod_filme = 2 ;

-- Helena B P Flausino
-- Filipe Vieira