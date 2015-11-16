-- Tabela Exame
-- Exame (código, nome, autorização, observação, tipo)
create table exame
(
	codigo varchar(4) primary key,
	nome varchar(30),
	autorizacao boolean, 
	observacao varchar(100),
	tipo varchar(11) check (tipo in ('Laboratório', 'Imagem'))
);

-- Tabela Médico
-- Médico (CRM, idade, nome)
create table medico
(
	CRM varchar(6) primary key,
	idade int,
	nome varchar(30)
);

-- Tabela Especialidade
--Especialidade (CRM, espec)
--	CRM referencia Médico
create table especialidade
(
	CRM varchar(6),
	espec varchar(20),
	foreign key (CRM) references medico(CRM)
);

-- Tabela Paciente
-- Paciente(CPF, nome, idade, telefone)
create table paciente
(
	CPF varchar(11) primary key,
	nome varchar(30),
	idade int,
	telefone varchar(9)
);

-- Tabela Endereço
-- Endereço (CEP, rua, bairro, cidade, estado)
create table endereco
(
	CEP varchar(8) primary key,
	rua varchar(35),
	bairro varchar(20),
	cidade varchar(20),
	estado varchar(2)
);

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
		on update cascade
		on delete set null
);

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
		on update cascade
		on delete cascade
);
	
-- Realiza (CRM, códigoExame)
-- 	CRM referencia Médico
-- 	CódigoExame referencia Exame
create table realiza
(
	CRM varchar(8),
	codigoExame varchar(4),
	primary key (CRM, codigoExame),
	
	foreign key (codigoExame) references exame(codigo)
		on update cascade
		on delete cascade,
	foreign key (CRM) references medico(CRM)
		on update cascade
		on delete cascade
);

-- Consulta (CRM, CPF, data)
-- 	CRM referencia Médico
-- 	CPF referencia Paciente
create table consulta
(
	CRM varchar(8),
	CPF varchar(11),
	data date,
	primary key (CRM, CPF, data),
	foreign key (CRM) references medico(CRM)
		on update cascade
		on delete set null,
	foreign key (CPF) references paciente(CPF)
		on update cascade
		on delete cascade
);

-- Solicita (CRM, data, CPF, códigoExame)
-- 	{CRM, CPF, data} referencia Consulta
create table solicita
(
	CRM varchar(8),
	data date,
	CPF varchar(11),
	codigoExame varchar(4),
	primary key (CRM, data, CPF, codigoExame),
	foreign key (CRM, CPF, data) references consulta(CRM, CPF, data)
		on update cascade
		on delete cascade,
	foreign key (codigoExame) references exame(codigo)
		on update cascade
		on delete set null
);
 
-- Atua (CRM, códigoClínica)
-- 	CRM referencia Médico
-- 	códigoClínica referencia Clínica
create table atua
(
	CRM varchar(8),
	codigoClinica varchar(4),
	primary key (CRM, codigoClinica),
	foreign key (CRM) references medico(CRM)
		on update cascade
		on delete cascade,
	foreign key (codigoClinica) references clinica(codigo)
		on update cascade
		on delete cascade
);
 
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
	foreign key (codigoExame) references exame(codigo)
		on update cascade
		on delete cascade,
	foreign key (codigoClinica) references clinica(codigo)
		on update cascade
		on delete cascade
);
 
-- Atendimento (códigoClínica, início, término)
-- 	códigoClínica referencia Clínica
create table atendimento
(
	codigoClinica varchar(4),
	inicio time,
	termino time check (termino > inicio),
	primary key (codigoClinica, inicio),
	foreign key (codigoClinica) references clinica(codigo)
		on update cascade
		on delete cascade
);

--drop table atendimento

-- Equipamento (código, nome, descrição) 
create table equipamento
(
	codigo varchar(4) primary key,
	nome varchar(20),
	descricao varchar(50)
);
 
-- Utiliza (códigoExame, códigoEquipamento)
create table utiliza
(
	codigoExame varchar(4),
	codigoEquipamento varchar(4),
	primary key (codigoExame, codigoEquipamento),
	
	foreign key (codigoExame) references exame(codigo)
		on update cascade
		on delete cascade,
	foreign key (codigoEquipamento) references equipamento(codigo)
		on update cascade
		on delete cascade
);
