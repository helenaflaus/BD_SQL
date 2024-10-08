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
INSERT INTO sessao VALUES ( default, current_date, 0, 0,'T','Ingles','Coppola');
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
INSERT INTO horario VALUES (16, '16:00:00');
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











	 
