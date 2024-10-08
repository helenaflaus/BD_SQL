-- Helena B P Flausino
-- 1. Mostrar o nome dos funcionários que nunca trabalharam em escalas de trabalho (horário) em que foram exibidos filmes brasileiros. Resolva de três formas diferentes.
-- 1.1: subconsulta com NOT IN

SELECT nome_func as Funcionários
FROM funcionario
WHERE cod_funcional NOT IN (
    SELECT DISTINCT cod_funcional
    FROM escala_trabalho
    JOIN sessao ON escala_trabalho.cod_horario = sessao.cod_horario
    JOIN filme ON sessao.cod_filme = filme.cod_filme
    WHERE filme.nacionalidade = 'Brasil'
);
-- 1.2: EXCEPT
SELECT nome_func
FROM funcionario
EXCEPT
SELECT DISTINCT f.nome_func
FROM funcionario f
JOIN escala_trabalho et ON f.cod_funcional = et.cod_funcional
JOIN sessao s ON et.cod_horario = s.cod_horario
JOIN filme fi ON s.cod_filme = fi.cod_filme
WHERE fi.nacionalidade = 'Brasil';

--2. Mostrar para cada sessão de exibição uma classificação baseada no percentual de ocupação.
--Considerações:
--Abaixo de 50% -> INSATISFATORIO
--Entre 50 e 80% -> SATISFATORIO
--Acima de 80% -> EXCELENTE
SELECT 
    ss.num_sessao,
    f.titulo_portugues,
    sa.nome_sala,
    ss.publico,
    sa.capacidade_sala,
    CASE 
        WHEN (ss.publico / sa.capacidade_sala::FLOAT) < 0.5 THEN 'INSATISFATORIO'
        WHEN (ss.publico / sa.capacidade_sala::FLOAT) BETWEEN 0.5 AND 0.8 THEN 'SATISFATORIO'
        ELSE 'EXCELENTE'
    END AS nivel_de_ocupacao
FROM sessao ss
JOIN filme f ON ss.cod_filme = f.cod_filme
JOIN sala sa ON ss.nome_sala = sa.nome_sala 
ORDER BY ss.num_sessao ;

-- 3. Mostrar o nome da sala campeã de rentabilidade (renda total/público total) para todas as sessões exibidas este ano.
SELECT 
    ss.nome_sala,
    SUM(ss.renda_sessao) / SUM(ss.publico) AS maior_rentabilidade
FROM sessao ss
WHERE EXTRACT(YEAR FROM ss.dt_sessao) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY ss.nome_sala
ORDER BY maior_rentabilidade DESC ;

-- 4. Mostrar as funcionárias (nome) que trabalham juntas na mesma escala de trabalho (dia da semana e horário). 
-- Nome Funcionária – Dia Semana – Horário. 
-- Se necessário cadastre mais escalas de trabalho.

-- 4.1 aqui selecionando TODOS que estão no mesmo dia e mesmo horario (todas combinações existentes em pares)
SELECT 
    f1.nome_func AS funcionaria1,
    f2.nome_func AS funcionaria2,
    et.dia_semana,
    et.cod_horario
FROM 
    escala_trabalho et
JOIN 
    funcionario f1 ON et.cod_funcional = f1.cod_funcional
JOIN 
    funcionario f2 ON et.cod_funcional != f2.cod_funcional
WHERE 
    f1.nome_func < f2.nome_func
    AND EXISTS (
        SELECT 1
        FROM escala_trabalho et2
        WHERE et2.cod_funcional = f2.cod_funcional
            AND et2.dia_semana = et.dia_semana
            AND et2.cod_horario = et.cod_horario
    );

-- 4.2 aqui selecionando funcionarias/os do mesmo sexo nos mesmos dias e horarios
SELECT 
    f1.nome_func AS funcionaria1,
    f2.nome_func AS funcionaria2,
    et.dia_semana,
    et.cod_horario
FROM 
    escala_trabalho et
JOIN 
    funcionario f1 ON et.cod_funcional = f1.cod_funcional
JOIN 
    funcionario f2 ON et.cod_funcional != f2.cod_funcional
WHERE 
    f1.nome_func < f2.nome_func
    AND f1.sexo_func = f2.sexo_func 
    AND EXISTS (
        SELECT 1
        FROM escala_trabalho et2
        WHERE et2.cod_funcional = f2.cod_funcional
            AND et2.dia_semana = et.dia_semana
            AND et2.cod_horario = et.cod_horario
    );

-- 4.3 aqui selecionando apenas FUNCIONARIAS MULHERES no mesmo dia e mesmo horario
SELECT 
    f1.nome_func AS funcionaria1,
    f2.nome_func AS funcionaria2,
    et.dia_semana,
    et.cod_horario
FROM 
    escala_trabalho et
JOIN 
    funcionario f1 ON et.cod_funcional = f1.cod_funcional
JOIN 
    funcionario f2 ON et.cod_funcional != f2.cod_funcional
WHERE 
    f1.nome_func < f2.nome_func
    AND f1.sexo_func = 'F'  
    AND f2.sexo_func = 'F'  
    AND EXISTS (
        SELECT 1
        FROM escala_trabalho et2
        WHERE et2.cod_funcional = f2.cod_funcional
            AND et2.dia_semana = et.dia_semana
            AND et2.cod_horario = et.cod_horario
    );






