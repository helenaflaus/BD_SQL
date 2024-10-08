
CREATE TABLE teste.Pessoa (
                Id_Pessoa BIGINT NOT NULL,
                Nome VARCHAR(50) NOT NULL,
                Tipo_Pessoa CHAR(2) DEFAULT PF NOT NULL,
                CONSTRAINT pessoa_pk PRIMARY KEY (Id_Pessoa)
);


CREATE TABLE teste.Veiculo (
                Placa CHAR(7) NOT NULL,
                Categoria CHAR(15) NOT NULL,
                Marca VARCHAR(20) NOT NULL,
                Modelo VARCHAR(20) NOT NULL,
                Cor CHAR(10) NOT NULL,
                Ano_Fabricacao SMALLINT NOT NULL,
                CONSTRAINT placa_pk PRIMARY KEY (Placa)
);


CREATE TABLE teste.Propriedade (
                Placa CHAR(7) NOT NULL,
                Id_Pessoa BIGINT NOT NULL,
                Data_Aquisicao DATE NOT NULL,
                Valor_Aquisicao NUMERIC(10,2) NOT NULL,
                Data_Venda DATE,
                CONSTRAINT propriedade_pk PRIMARY KEY (Placa, Id_Pessoa, Data_Aquisicao)
);


ALTER TABLE teste.Propriedade ADD CONSTRAINT pessoa_propriedade_fk
FOREIGN KEY (Id_Pessoa)
REFERENCES teste.Pessoa (Id_Pessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE teste.Propriedade ADD CONSTRAINT veiculo_propriedade_fk
FOREIGN KEY (Placa)
REFERENCES teste.Veiculo (Placa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
