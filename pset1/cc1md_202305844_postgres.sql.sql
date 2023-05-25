
-- Deletar Usuário, Schema e Banco de dados se existir

DROP SCHEMA IF EXISTS lojas;
DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS nicolas;

-- Criar usuário, banco de dados e schemas

CREATE USER nicolas createdb createrole password 'computacao@raiz';


CREATE DATABASE uvv
WITH
OWNER = nicolas
TEMPLATE = template0
ENCODING = "UTF8"
lc_collate = 'pt_BR.UTF-8'
lc_ctype = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = true;

\c uvv;
set role nicolas;

CREATE SCHEMA lojas;
SET SEARCH_PATH TO lojas, "$user", public;
COMMENT ON SCHEMA LOJAS IS 'schema loja que serve para facilitar a organizacao da criacao das tabelas';

-- Produtos

CREATE TABLE uvv.lojas.produtos (
                produto_id                  NUMERIC(38)     NOT NULL,
                nome                        VARCHAR(255)    NOT NULL,
                preco_unitario              NUMERIC(10,2)   NOT NULL    CHECK (preco_unitario >= 0),
                detalhes                    BYTEA           NOT NULL,
                imagem                      BYTEA           NOT NULL,
                imagem_mime_type            VARCHAR(512)    NOT NULL,
                imagem_arquivo              VARCHAR(512)    NOT NULL,
                imagem_charset              VARCHAR(512)    NOT NULL,
                imagem_ultime_atualizacao   DATE            NOT NULL,

                CONSTRAINT produtos_pk PRIMARY KEY (produto_id)
);
COMMENT ON TABLE lojas.produtos IS 'Armazena os dados dos produtos';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'Armazena a PK da tabela produto';
COMMENT ON COLUMN lojas.produtos.nome IS 'Armazena o nome do protudo na tabela produtos';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'Armazena o preco da unidade';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'Armazena os detalhes dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem IS 'Armazena a imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'Armazena o tipo de midia do produto';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'Armazena o arquivo do produto';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'Armazena o charset do produto';
COMMENT ON COLUMN lojas.produtos.imagem_ultime_atualizacao IS 'Armazena a ultima vez que a imagem do produto foi alterada';

-- Lojas

CREATE TABLE uvv.lojas.lojas (
                loja_id                     NUMERIC(38)     NOT NULL,
                nome                        VARCHAR(255)    NOT NULL,
                endereco_web                VARCHAR(100)    CHECK (endereco_web <> endereco_fisico),
                endereco_fisico             VARCHAR(512)    CHECK (endereco_fisico <> endereco_web),
                latitude                    NUMERIC         NOT NULL,
                logo                        BYTEA           NOT NULL,
                logo_mime_type              VARCHAR(512)    NOT NULL,
                logo_arquivo                VARCHAR(512)    NOT NULL,
                logo_charset                VARCHAR(512)    NOT NULL,
                logo_ultima_atualizacao     DATE            NOT NULL,

                CONSTRAINT lojas_pk PRIMARY KEY (loja_id)
);
COMMENT ON TABLE lojas.lojas IS 'Tabela que guarda informacoes da loja';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'Armazena a PK da tabela loja';
COMMENT ON COLUMN lojas.lojas.nome IS 'Armazena os nomes das lojas';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'Armazena o endereco web das lojas';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'Armazena o endereco fisico das lojas';
COMMENT ON COLUMN lojas.lojas.latitude IS 'Armazena a latitude da loja';
COMMENT ON COLUMN lojas.lojas.logo IS 'Armazena a logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'Armazena o tipo de midia da logo';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'Armazena o arquivo da logo';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'Armazena o charset da logo';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Armazena a data da ultima atualizacao da logo';

-- Estoques

CREATE TABLE uvv.lojas.estoques (
                estoque_id                  NUMERIC(38)     NOT NULL,
                loja_id                     NUMERIC(38)     NOT NULL,
                produto_id                  NUMERIC(38)     NOT NULL,
                quantidade                  NUMERIC(38)     NOT NULL,

                CONSTRAINT estoques_pk PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE lojas.estoques IS 'Guarda as informacoes de estoques dos produtos';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Armazena a PK da tabela estoques';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'Armazena a PK da tabela loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'Armazena a PK da tabela produto';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Armazena a quantidade';

-- Clientes

CREATE TABLE uvv.lojas.clientes (
                cliente_id                  NUMERIC(38)     NOT NULL,
                email                       VARCHAR(255)    NOT NULL,
                nome                        VARCHAR(255)    NOT NULL,
                telefone1                   VARCHAR(20)     NOT NULL,
                telefone2                   VARCHAR(20),
                telefone3                   VARCHAR(20),

                CONSTRAINT clientes_pk PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE lojas.clientes IS 'Tabela que armazena os dados dos clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Armazena a PK da tabela clientes';
COMMENT ON COLUMN lojas.clientes.email IS 'Armazena o email na tabela clientes';
COMMENT ON COLUMN lojas.clientes.nome IS 'Armazena o nome do cliente na tabela clientes';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'Armazena o telefone na tabela clientes';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'Armazena o telefone na tabela clientes';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'Armazena o telefone na tabela clientes';

-- Envios

CREATE TABLE uvv.lojas.envios (
                envio_id                    NUMERIC(38)     NOT NULL,
                endereco_entrega            VARCHAR(512)    NOT NULL,
                status                      VARCHAR(15)     NOT NULL        CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE')),
                cliente_id                  NUMERIC(38)     NOT NULL,

                CONSTRAINT envios_pk PRIMARY KEY (envio_id)
);
COMMENT ON TABLE lojas.envios IS 'Guarda as informacoes dos envios';
COMMENT ON COLUMN lojas.envios.envio_id IS 'Armazena a PK da tabela envios';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Armazena o endereco que sera entregue';
COMMENT ON COLUMN lojas.envios.status IS 'Armazenas os status da entrega';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'Armazena a PK da tabela clientes';

-- Pedidos

CREATE TABLE uvv.lojas.pedidos (
                pedidos_id                  NUMERIC(38)     NOT NULL,
                data_hora                   TIMESTAMP       NOT NULL,
                cliente_id                  NUMERIC(38)     NOT NULL,
                status                      VARCHAR(15)     NOT NULL        CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO')),
                loja_id                     NUMERIC(38)     NOT NULL,

                CONSTRAINT pedidos_pk PRIMARY KEY (pedidos_id)
);
COMMENT ON TABLE lojas.pedidos IS 'Tabela que registra os pedidos';
COMMENT ON COLUMN lojas.pedidos.pedidos_id IS 'Armazena a PK da tabela pedidos';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'Armazena a data e a hora';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Armazena a PK da tabela clientes';
COMMENT ON COLUMN lojas.pedidos.status IS 'Armazena os status do pedido';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'Armazena a PK da tabela loja';

-- Pedidos_itens

CREATE TABLE uvv.lojas.pedidos_itens (
                produto_id                  NUMERIC(38)     NOT NULL,
                pedidos_id                  NUMERIC(38)     NOT NULL,
                numero_da_linha             NUMERIC(38)     NOT NULL,
                preco_unitario              NUMERIC(10,2)   NOT NULL,
                quantidade                  NUMERIC(38)     NOT NULL,
                envio_id                    NUMERIC(38)     NOT NULL,
                
                CONSTRAINT pedidos_itens_pk PRIMARY KEY (produto_id, pedidos_id)
);
COMMENT ON TABLE lojas.pedidos_itens IS 'Armazena os dados entre pedidos e itens';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'Armazena a PK da tabela produto';
COMMENT ON COLUMN lojas.pedidos_itens.pedidos_id IS 'Armazena a PK da tabela pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Armazena o numero da linha';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'Armazena o preço unitario dos itens';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'Armazena a quantidade de intens';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'Armazena a PK da tabela envios';


ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedidos_id)
REFERENCES lojas.pedidos (pedidos_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
