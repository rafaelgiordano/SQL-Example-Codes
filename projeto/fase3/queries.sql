-- Tabela Exame
-- Exame (código, nome, autorização, observação, tipo)
create table exame
(
	codigo varchar(4) primary key,
	nome varchar(30),
	autorizacao boolean, 
	observacao varchar(100),
	tipo varchar(11) check (tipo in ('Laboratório', 'Imagem'))
)

-- Tabela Médico
-- Médico (CRM, idade, nome)
create table medico
(
	CRM varchar(6) primary key,
	idade int,
	nome varchar(30)
)

-- Tabela Especialidade
--Especialidade (CRM, espec)
--	CRM referencia Médico
create table especialidade
(
	CRM varchar(4),
	espec varchar(20),
	foreign key (CRM) references medico(CRM)
)

-- Tabela Paciente
-- Paciente(CPF, nome, idade, telefone)
create table paciente
(
	CPF varchar(11) primary key,
	nome varchar(30),
	idade int,
	telefone varchar(9)
)

-- Tabela Endereço
-- Endereço (CEP, rua, bairro, cidade, estado)
create table endereco
(
	CEP varchar(8) primary key,
	rua varchar(35),
	bairro varchar(20),
	cidade varchar(20),
	estado varchar(2)
)

-- Tabela Clínica
-- Clínica (código, nome, CEP, número, telefone1, telefone2)
--	CEP referencia Endereço
create table clinica
(
	codigo varchar(4) primary key,
	nome varchar(20),
	CEP varchar(8),
	numero int,
	telefone1 varchar(9),
	telefone2 varchar(9),
	foreign key (CEP) references endereco(CEP)
)

-- Tabela Orientação
-- Orientação (códigoExame, número, instrução)
--       códigoExame referencia Exame
create table orientacao
(
	codigoExame varchar(4),
	numero int,
	instrucao varchar(40),
	primary key (codigoExame, numero),
	foreign key (codigoExame) references exame(codigo)
)
	
-- Realiza (CRM, códigoExame)
-- 	CRM referencia Médico
-- 	CódigoExame referencia Exame
create table realiza
(
	CRM varchar(8),
	codigoExame varchar(4),
	primary key (CRM, codigoExame),
	foreign key (codigoExame) references exame(codigo),
	foreign key (CRM) references medico(CRM)
	
)

-- Consulta (CRM, CPF, data)
-- 	CRM referencia Médico
-- 	CPF referencia Paciente
create table consulta
(
	CRM varchar(8),
	CPF varchar(8),
	data date,
	primary key (CRM, CPF, data),
	foreign key (CRM) references medico(CRM),
	foreign key (CPF) references paciente(CPF)
)

-- Solicita (CRM, data, CPF, códigoExame)
-- 	{CRM, CPF, data} referencia Consulta
create table solicita
(
	CRM varchar(8),
	data date,
	CPF varchar(8),
	codigoExame varchar(4),
	primary key (CRM, data, CPF, codigoExame),
	foreign key (CRM, CPF, data) references consulta(CRM, CPF, data),
	foreign key (codigoExame) references exame(codigo)
)
 
-- Atua (CRM, códigoClínica)
-- 	CRM referencia Médico
-- 	códigoClínica referencia Clínica
create table atua
(
	CRM varchar(8),
	codigoClinica varchar(4),
	primary key (CRM, codigoClinica),
	foreign key (CRM) references medico(CRM),
	foreign key (codigoClinica) references clinica(codigo)
)
 
-- Oferece (códigoExame, códigoClínica, ativo, agendamento, prazoEntrega)
-- 	códigoExame referencia Exame
-- 	códigoClínica referencia Clínica
create table oferece
(
	codigoExame varchar(4),
	codigoClinica varchar(4),
	ativo boolean,
	agendamento boolean,
	prazoEntrega int,
	primary key (codigoExame, codigoClinica),
	foreign key (codigoExame) references exame(codigo),
	foreign key (codigoClinica) references clinica(codigo)
)
 
-- Atendimento (códigoClínica, início, término)
-- 	códigoClínica referencia Clínica
create table atendimento
(
	codigoClinica varchar(4),
	inicio time,
	termino time check (termino > inicio),
	primary key (codigoClinica, inicio),
	foreign key (codigoClinica) references clinica(codigo)
)

drop table atendimento

-- Equipamento (código, nome, descrição) 
create table equipamento
(
	codigo varchar(4) primary key,
	nome varchar(20),
	descricao varchar(50)
)
 
-- Utiliza (códigoExame, códigoEquipamento)
create table utiliza
(
	codigoExame varchar(4),
	codigoEquipamento varchar(4),
	primary key (codigoExame, codigoEquipamento),
	foreign key (codigoExame) references exame(codigo),
	foreign key (codigoEquipamento) references equipamento(codigo)
)

insert into medico values ('12345678', 20, 'Jose')
insert into exame values  ('1234', 'sangue', true, 'observacao', 'Laboratório')
insert into realiza values ('12345678', '87654321')
delete from realiza where CRM = '123456789'

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
-- RD12) Consulta que recupera a quantidade de solicitações de exames pela data.
-- RD13) Consulta que conta os exames oferecidos por uma clínica.

-- RD14) Consulta que recupera os exames pela letra inicial.
select * from paciente
where exame.nome like '%';

alter table especialidade
alter CRM type varchar(6)

alter table solicita
alter CPF type varchar(11)

insert into medico values ('222312', 36, 'Lucas Miola')
insert into exame values  ('1221', 'tomografia', true, 'obs', 'Imagem')
delete from exame where (exame.codigo = '1221')

insert into realiza values ('12345678', '87654321')

insert into paciente values ('55873313512', 'Natasha', '17', '33331333')
delete from medico where (medico.nome = 'Ramon')

insert into especialidade values ('222312', 'Neurologista')
insert into endereco values ('18081999', 'Maria da Graca', 'Vila Aro', 'Sorocaba', 'SP')

insert into clinica values ('9022', 'Clinica Bom Jesus', '18081999', '195', '94856488', '95688475')

insert into orientacao values ('1221', '1', 'nao se mexer')

insert into realiza values ('222312', '1221')

insert into consulta values ('222312', '91132131111', '2007-10-25')

insert into atendimento values ('9022', '18:00:00', '21:00:00')

insert into oferece values ('1221', '9022' , true, true , '11')

insert into solicita values ('222312', '2007-10-25','91132131111', '1221')

insert into atua values ('222312', '9022')

select * from clinica

insert into oferece values ('1221', '5122' , true, false , '11')