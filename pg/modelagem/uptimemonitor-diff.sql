-- Database diff generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.0
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 1
-- Created objects: 24
-- Changed objects: 1
-- Truncated tables: 0

SET search_path=public,pg_catalog,seguranca,administracao,operacional;
-- ddl-end --


-- [ Dropped objects ] --
DROP EXTENSION IF EXISTS pg_catalog.adminpack;
-- ddl-end --


-- [ Created objects ] --
-- object: seguranca | type: SCHEMA --
-- DROP SCHEMA IF EXISTS seguranca CASCADE;
CREATE SCHEMA seguranca;
-- ddl-end --
ALTER SCHEMA seguranca OWNER TO postgres;
-- ddl-end --

-- object: seguranca.usuario | type: TABLE --
-- DROP TABLE IF EXISTS seguranca.usuario CASCADE;
CREATE TABLE seguranca.usuario(
	id smallserial NOT NULL,
	nome character varying(100) NOT NULL,
	login character varying(50) NOT NULL,
	senha character varying(250) NOT NULL,
	idusuariocadastro smallint NOT NULL,
	datacadastro timestamp NOT NULL,
	idusuarioalteracao smallint,
	dataalteracao timestamp,
	CONSTRAINT pk_usuario PRIMARY KEY (id),
	CONSTRAINT uq_usuario_login UNIQUE (login)

);
-- ddl-end --
COMMENT ON TABLE seguranca.usuario IS 'usuarios do sistema';
-- ddl-end --
COMMENT ON CONSTRAINT uq_usuario_login ON seguranca.usuario  IS 'Login deve ser unico';
-- ddl-end --
ALTER TABLE seguranca.usuario OWNER TO postgres;
-- ddl-end --

-- object: seguranca.email | type: TABLE --
-- DROP TABLE IF EXISTS seguranca.email CASCADE;
CREATE TABLE seguranca.email(
	id smallserial NOT NULL,
	email character varying(100) NOT NULL,
	principal boolean NOT NULL,
	idusuariocadastro smallint NOT NULL,
	datacadastro timestamp NOT NULL,
	idusuarioalteracao smallint,
	dataalteracao timestamp,
	CONSTRAINT pk_email PRIMARY KEY (id),
	CONSTRAINT uq_email_email UNIQUE (email)

);
-- ddl-end --
COMMENT ON TABLE seguranca.email IS 'Tabela para emails dos usuarios';
-- ddl-end --
COMMENT ON CONSTRAINT uq_email_email ON seguranca.email  IS 'Email deve ser unico';
-- ddl-end --
ALTER TABLE seguranca.email OWNER TO postgres;
-- ddl-end --

-- object: seguranca.usuarioemail | type: TABLE --
-- DROP TABLE IF EXISTS seguranca.usuarioemail CASCADE;
CREATE TABLE seguranca.usuarioemail(
	idusuario smallint NOT NULL,
	idemail smallint NOT NULL,
	CONSTRAINT pk_usuarioemail PRIMARY KEY (idusuario,idemail)

);
-- ddl-end --
COMMENT ON TABLE seguranca.usuarioemail IS 'Relacionamento usuario com email';
-- ddl-end --
ALTER TABLE seguranca.usuarioemail OWNER TO postgres;
-- ddl-end --

-- object: administracao | type: SCHEMA --
-- DROP SCHEMA IF EXISTS administracao CASCADE;
CREATE SCHEMA administracao;
-- ddl-end --
ALTER SCHEMA administracao OWNER TO postgres;
-- ddl-end --

-- object: administracao.sistema | type: TABLE --
-- DROP TABLE IF EXISTS administracao.sistema CASCADE;
CREATE TABLE administracao.sistema(
	id smallserial NOT NULL,
	nome character varying(100) NOT NULL,
	ativo boolean NOT NULL,
	idusuariocadastro smallint NOT NULL,
	idusuarioalteracao smallint,
	datacadastro timestamp NOT NULL,
	dataalteracao timestamp,
	CONSTRAINT pk_sistema PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE administracao.sistema IS 'Tabela de sistemas';
-- ddl-end --
ALTER TABLE administracao.sistema OWNER TO postgres;
-- ddl-end --

-- object: operacional | type: SCHEMA --
-- DROP SCHEMA IF EXISTS operacional CASCADE;
CREATE SCHEMA operacional;
-- ddl-end --
ALTER SCHEMA operacional OWNER TO postgres;
-- ddl-end --

-- object: operacional.monitor | type: TABLE --
-- DROP TABLE IF EXISTS operacional.monitor CASCADE;
CREATE TABLE operacional.monitor(
	id smallserial NOT NULL,
	nome character varying(100) NOT NULL,
	url character varying(150) NOT NULL,
	up boolean,
	idusuariocadastro smallint NOT NULL,
	datacadastro timestamp NOT NULL,
	idusuarioalteracao smallint,
	dataalteracao timestamp,
	updataalteracao timestamp NOT NULL,
	CONSTRAINT pk_monitor PRIMARY KEY (id),
	CONSTRAINT uq_monitor_nome UNIQUE (nome),
	CONSTRAINT uq_monitor_url UNIQUE (url)

);
-- ddl-end --
COMMENT ON TABLE operacional.monitor IS 'Monitor para verificar se um endpoint está de pé';
-- ddl-end --
COMMENT ON COLUMN operacional.monitor.up IS 'Indicador se  o endpoint está de pé';
-- ddl-end --
COMMENT ON COLUMN operacional.monitor.updataalteracao IS 'Data da ultima alteração do status up';
-- ddl-end --
ALTER TABLE operacional.monitor OWNER TO postgres;
-- ddl-end --

-- object: operacional.monitoremail | type: TABLE --
-- DROP TABLE IF EXISTS operacional.monitoremail CASCADE;
CREATE TABLE operacional.monitoremail(
	idemail smallint NOT NULL,
	idmonitor smallint NOT NULL,
	CONSTRAINT pk_monitoremail PRIMARY KEY (idemail,idmonitor)

);
-- ddl-end --
COMMENT ON TABLE operacional.monitoremail IS 'Vinculo do monitor com os emails';
-- ddl-end --
ALTER TABLE operacional.monitoremail OWNER TO postgres;
-- ddl-end --

-- object: operacional.monitorusuario | type: TABLE --
-- DROP TABLE IF EXISTS operacional.monitorusuario CASCADE;
CREATE TABLE operacional.monitorusuario(
	idusuario smallint NOT NULL,
	idmonitor smallint NOT NULL,
	read boolean NOT NULL,
	write boolean NOT NULL,
	owner boolean NOT NULL,
	ativo boolean NOT NULL,
	CONSTRAINT pk_monitorusuario PRIMARY KEY (idusuario,idmonitor)

);
-- ddl-end --
COMMENT ON TABLE operacional.monitorusuario IS 'Vinculo monitor usuario';
-- ddl-end --
COMMENT ON COLUMN operacional.monitorusuario.read IS 'Permissão leitura';
-- ddl-end --
COMMENT ON COLUMN operacional.monitorusuario.write IS 'Permissão escrita';
-- ddl-end --
COMMENT ON COLUMN operacional.monitorusuario.owner IS 'Permissão proprietário (apenas um owner pode excluir o monitor)';
-- ddl-end --
COMMENT ON COLUMN operacional.monitorusuario.ativo IS 'Apenas fica ativo o usuário no monitor se ele aceitar';
-- ddl-end --
ALTER TABLE operacional.monitorusuario OWNER TO postgres;
-- ddl-end --



-- [ Changed objects ] --
ALTER DATABASE postgres RENAME TO uptimemonitor;
-- ddl-end --
COMMENT ON DATABASE uptimemonitor IS '';
-- ddl-end --


-- [ Created foreign keys ] --
-- object: fk_usuarioemail_usuario | type: CONSTRAINT --
-- ALTER TABLE seguranca.usuarioemail DROP CONSTRAINT IF EXISTS fk_usuarioemail_usuario CASCADE;
ALTER TABLE seguranca.usuarioemail ADD CONSTRAINT fk_usuarioemail_usuario FOREIGN KEY (idusuario)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usuarioemail_email | type: CONSTRAINT --
-- ALTER TABLE seguranca.usuarioemail DROP CONSTRAINT IF EXISTS fk_usuarioemail_email CASCADE;
ALTER TABLE seguranca.usuarioemail ADD CONSTRAINT fk_usuarioemail_email FOREIGN KEY (idemail)
REFERENCES seguranca.email (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usuario_usuario_cadastro | type: CONSTRAINT --
-- ALTER TABLE seguranca.usuario DROP CONSTRAINT IF EXISTS fk_usuario_usuario_cadastro CASCADE;
ALTER TABLE seguranca.usuario ADD CONSTRAINT fk_usuario_usuario_cadastro FOREIGN KEY (idusuariocadastro)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usuario_usuario_alteracao | type: CONSTRAINT --
-- ALTER TABLE seguranca.usuario DROP CONSTRAINT IF EXISTS fk_usuario_usuario_alteracao CASCADE;
ALTER TABLE seguranca.usuario ADD CONSTRAINT fk_usuario_usuario_alteracao FOREIGN KEY (idusuarioalteracao)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_email_usuario_cadastro | type: CONSTRAINT --
-- ALTER TABLE seguranca.email DROP CONSTRAINT IF EXISTS fk_email_usuario_cadastro CASCADE;
ALTER TABLE seguranca.email ADD CONSTRAINT fk_email_usuario_cadastro FOREIGN KEY (idusuariocadastro)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_email_usuario_alteracao | type: CONSTRAINT --
-- ALTER TABLE seguranca.email DROP CONSTRAINT IF EXISTS fk_email_usuario_alteracao CASCADE;
ALTER TABLE seguranca.email ADD CONSTRAINT fk_email_usuario_alteracao FOREIGN KEY (idusuarioalteracao)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_sistema_usuario_cadastro | type: CONSTRAINT --
-- ALTER TABLE administracao.sistema DROP CONSTRAINT IF EXISTS fk_sistema_usuario_cadastro CASCADE;
ALTER TABLE administracao.sistema ADD CONSTRAINT fk_sistema_usuario_cadastro FOREIGN KEY (idusuariocadastro)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_sistema_usuario_alteracao | type: CONSTRAINT --
-- ALTER TABLE administracao.sistema DROP CONSTRAINT IF EXISTS fk_sistema_usuario_alteracao CASCADE;
ALTER TABLE administracao.sistema ADD CONSTRAINT fk_sistema_usuario_alteracao FOREIGN KEY (idusuarioalteracao)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_monitor_usuario_cadastro | type: CONSTRAINT --
-- ALTER TABLE operacional.monitor DROP CONSTRAINT IF EXISTS fk_monitor_usuario_cadastro CASCADE;
ALTER TABLE operacional.monitor ADD CONSTRAINT fk_monitor_usuario_cadastro FOREIGN KEY (idusuariocadastro)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_monitor_usuario_alteracao | type: CONSTRAINT --
-- ALTER TABLE operacional.monitor DROP CONSTRAINT IF EXISTS fk_monitor_usuario_alteracao CASCADE;
ALTER TABLE operacional.monitor ADD CONSTRAINT fk_monitor_usuario_alteracao FOREIGN KEY (idusuarioalteracao)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_monitoremail_email | type: CONSTRAINT --
-- ALTER TABLE operacional.monitoremail DROP CONSTRAINT IF EXISTS fk_monitoremail_email CASCADE;
ALTER TABLE operacional.monitoremail ADD CONSTRAINT fk_monitoremail_email FOREIGN KEY (idemail)
REFERENCES seguranca.email (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_monitoremail_monitor | type: CONSTRAINT --
-- ALTER TABLE operacional.monitoremail DROP CONSTRAINT IF EXISTS fk_monitoremail_monitor CASCADE;
ALTER TABLE operacional.monitoremail ADD CONSTRAINT fk_monitoremail_monitor FOREIGN KEY (idmonitor)
REFERENCES operacional.monitor (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_monitorusuario_usuario | type: CONSTRAINT --
-- ALTER TABLE operacional.monitorusuario DROP CONSTRAINT IF EXISTS fk_monitorusuario_usuario CASCADE;
ALTER TABLE operacional.monitorusuario ADD CONSTRAINT fk_monitorusuario_usuario FOREIGN KEY (idusuario)
REFERENCES seguranca.usuario (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_monitorusuario_monitor | type: CONSTRAINT --
-- ALTER TABLE operacional.monitorusuario DROP CONSTRAINT IF EXISTS fk_monitorusuario_monitor CASCADE;
ALTER TABLE operacional.monitorusuario ADD CONSTRAINT fk_monitorusuario_monitor FOREIGN KEY (idmonitor)
REFERENCES operacional.monitor (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

