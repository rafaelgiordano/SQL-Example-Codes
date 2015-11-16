
-- CONSULTAS

-- RD04) Consulta que recupera os exames pelo tipo
select exame.tipo as tipo, exame.codigo as codigo, exame.nome as nome, exame.observacao as observacao from exame
order by tipo

-- RD05) Consulta que recupera os exames pelo nome
select exame.nome as nome, exame.codigo as codigo, exame.observacao as observacao, exame.tipo as tipo from exame
order by nome

-- RD06) Consulta que recupera as clinicas pelo exame
select exame.nome as nome_exame, exame.codigo as codigo_exame, clinica.nome as nome_clinica, clinica.codigo as codigo_clinica from oferece, clinica, exame
where oferece.codigoExame = exame.codigo and oferece.codigoClinica = clinica.codigo
order by exame.nome

-- select count(*) from (select distinct codigo from engenheiros, engenh_projeto where engenheiros.codigo = engenh_projeto.engenheiro) as numero

-- RD07) Consulta que recupera os horários de atendimento de uma clínica.
select clinica.nome as nome_clinica, atendimento.inicio as inicio, atendimento.termino as termino from clinica, atendimento
where atendimento.codigoClinica = clinica.codigo

-- RD08) Consulta que recupera os médicos pela clínica.
select 

-- RD09) Consulta que recupera os médicos pelo exame.
select exame.nome as nome_exame, exame.codigo as codigo_exame, medico.nome as nome_medico, medico.CRM as crm_medico, medico.idade as idade_medico from realiza, exame, medico
where realiza.codigoExame = exame.codigo and realiza.CRM = medico.CRM
order by exame.nome

-- RD10) Consulta que recupera os exames pelo paciente.

-- RD11) Consulta que recupera o exame com mais solicitações.

select MAX ( select exame.nome, count (distinct exame.codigo) from solicita , exame) from solicita
group by exame.nome

--net select id_func from integrante group by id_func order by count(id_func) desc limit 1

select exame.nome as Exame ,count(distinct exame.codigo) as quant from solicita , exame
group by exame.nome 
order by count(codigoExame) desc limit 1

select exame.nome as Exame ,count(distinct exame.codigo) as quant from solicita , exame
group by exame.nome 
select MAX(quant) as maior from solicita
order by count(codigoExame) desc limit 1

-- com MAX

 Select codigoExame, count(codigoExame)

      from solicita

      group by codigoExame

      having count(codigoExame)=(Select max(quant.CNT)

      from (Select count(codigoExame) as CNT

      from solicita

      group by (codigoExame)) as quant)

      -- Modificando

Select codigoExame, exame.nome , count(codigoExame)

      from solicita, exame

      group by exame.nome, codigoExame 

      having count(codigoExame)=(Select max(quant.CNT)

      from (Select count(codigoExame) as CNT

      from solicita 

      group by (codigoExame)) as quant)

--
SELECT MAX(quant)
from(
SELECT nome, COUNT(*) as quant
 FROM solicita, exame
 WHERE codigoExame = exame.codigo 
 GROUP BY nome
)

Select exame.codigo, exame.nome, count(codigoExame)
from solicita, exame
where solicita.codigoExame = exame.codigo
group by exame.codigo 
having count(codigoExame)=(Select max(quant.CNT)
from (Select count(codigoExame) as CNT
from solicita
group by (codigoExame)) as quant)


-- RD12) Consulta que recupera a quantidade de solicitações de exames pela data.
Select solicita.data, exame.codigo, exame.nome 
from exame , solicita 
where solicita.data = '2010-11-25' and solicita.codigoExame = exame.codigo
order by solicita.data

select * from exame
select * from oferece
-- RD13) Consulta que conta os exames oferecidos por uma clínica.

select clinica.nome as Clinica,count(codigoExame) as quantidade_exames from clinica , oferece
where oferece.codigoclinica = '1000' AND clinica.codigo = oferece.codigoclinica
group by clinica.nome


-- RD14) Consulta que recupera os exames pela letra inicial.
select * from exame
where exame.nome like 'l';

--15) Recupera orientações pelo exame

select nome, instrucao from orientacao , exame
where orientacao.codigoExame = '8534' AND exame.codigo = orientacao.codigoExame
group by nome, instrucao

--mostrar os exames
select * from exame
-- 16) Recupera equipamentos por exame

select exame.nome as exame, equipamento.nome as aparelho, descricao from equipamento , exame , utiliza
where utiliza.codigoExame = '1020' AND exame.codigo = utiliza.codigoExame AND utiliza.codigoEquipamento = equipamento.codigo
group by exame.nome, equipamento.nome, descricao
