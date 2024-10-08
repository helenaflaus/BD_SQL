
/**** Atividade 4 **** - Helena Flausino
1– Mostrar os dados dos filmes do gênero Drama no formato : ‘Guerra nas Estrelas foi lançado em 1977 com classificação etária LIVRE’ 
2- Mostrar o título original, estúdio e ano de lançamento dos filmes que tem ‘GUERRA’ ou ‘BATALHA’ no nome e duram mais de 140 minutos 
3– Mostrar os dados dos funcionários mulheres que e que tem mais de 22 anos : Nome Funcionário-Idade 
4- Mostrar as sessões de cinema exibidas este ano que não tem som do tipo Surround: Número da Sessão – Data Sessão – Tipo Áudio  */


/* 1 */
SELECT INITCAP(titulo_original)||' foi lançado em '||
ano_lancamento||' com classificação etária '||UPPER(class_etaria)
AS "Dados Filme"
FROM filme
WHERE genero = 'Drama';

/* 2 (fiz alterações de seleção para testar com os filmes que tinha inserido) */
SELECT * FROM filme ; 
SELECT titulo_original, estudio, ano_lancamento
FROM filme
WHERE (titulo_original ILIKE '%TERRA%' OR titulo_original ILIKE '%III%') AND duracao_min > 100;

/* 3 */
SELECT * FROM funcionario ; 
SELECT nome_func, DATE_PART('year', AGE(NOW(), dt_nascto_func)) AS idade_aproximada
FROM funcionario
WHERE sexo_func = 'F' AND DATE_PART('year', AGE(NOW(), dt_nascto_func)) > 22;

/* 4 */
ALTER TABLE sessao
ADD COLUMN tipo_audio VARCHAR(35);

SELECT num_sessao, dt_sessao, tipo_audio 
FROM sessao 
WHERE EXTRACT(YEAR FROM dt_sessao) = EXTRACT(YEAR FROM CURRENT_DATE) ;
