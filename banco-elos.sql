CREATE DATABASE IF NOT EXISTS elos_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE elos_db;

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome             VARCHAR(150) NOT NULL,
    email            VARCHAR(254) NOT NULL,
    senha_hash       VARCHAR(255) NOT NULL,
    telefone         VARCHAR(25) NULL,
    data_cadastro    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status           ENUM('ATIVO', 'INATIVO') NOT NULL DEFAULT 'ATIVO',
    PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_email UNIQUE (email),
    INDEX idx_usuario_nome (nome),
    INDEX idx_usuario_status (status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS perfil (
    id_perfil       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_perfil     VARCHAR(80) NOT NULL,
    descricao       VARCHAR(255) NULL,
    PRIMARY KEY (id_perfil),
    CONSTRAINT uq_perfil_nome UNIQUE (nome_perfil)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS permissao (
    id_permissao   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_permissao VARCHAR(100) NOT NULL,
    descricao      VARCHAR(255) NULL,
    PRIMARY KEY (id_permissao),
    CONSTRAINT uq_permissao_nome UNIQUE (nome_permissao)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS usuario_perfil (
    id_usuario      BIGINT UNSIGNED NOT NULL,
    id_perfil       BIGINT UNSIGNED NOT NULL,
    data_atribuicao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_perfil),
    CONSTRAINT fk_usuario_perfil_usuario
      FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_usuario_perfil_perfil
      FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_usuario_perfil_perfil (id_perfil)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS permissao_perfil (
    id_perfil     BIGINT UNSIGNED NOT NULL,
    id_permissao  BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_perfil, id_permissao),
    CONSTRAINT fk_permissao_perfil_perfil
      FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_permissao_perfil_permissao
      FOREIGN KEY (id_permissao) REFERENCES permissao (id_permissao)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_permissao_perfil_permissao (id_permissao)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS cidadao (
    id_usuario BIGINT UNSIGNED NOT NULL,
    cpf        CHAR(11) NOT NULL,
    endereco   VARCHAR(255) NULL,
    PRIMARY KEY (id_usuario),
    CONSTRAINT uq_cidadao_cpf UNIQUE (cpf),
    CONSTRAINT fk_cidadao_usuario
      FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS funcionario (
    id_usuario  BIGINT UNSIGNED NOT NULL,
    matricula   VARCHAR(40) NOT NULL,
    departamento VARCHAR(100) NULL,
    PRIMARY KEY (id_usuario),
    CONSTRAINT uq_funcionario_matricula UNIQUE (matricula),
    CONSTRAINT fk_funcionario_usuario
      FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS gestor_social (
    id_usuario      BIGINT UNSIGNED NOT NULL,
    area_responsavel VARCHAR(150) NULL,
    PRIMARY KEY (id_usuario),
    CONSTRAINT fk_gestor_social_usuario
      FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS comunidade (
    id_comunidade BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_comunidade VARCHAR(150) NOT NULL,
    bairro_distrito VARCHAR(120) NULL,
    municipio      VARCHAR(120) NOT NULL,
    estado         CHAR(2) NOT NULL,
    descricao      TEXT NULL,
    status         ENUM('ATIVO', 'INATIVO') NOT NULL DEFAULT 'ATIVO',
    PRIMARY KEY (id_comunidade),
    INDEX idx_comunidade_localidade (municipio, estado),
    INDEX idx_comunidade_status (status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS categoria (
    id_categoria   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_categoria VARCHAR(100) NOT NULL,
    descricao      VARCHAR(255) NULL,
    PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categoria_nome UNIQUE (nome_categoria)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS prioridade (
    id_prioridade   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_prioridade VARCHAR(60) NOT NULL,
    descricao       VARCHAR(255) NULL,
    PRIMARY KEY (id_prioridade),
    CONSTRAINT uq_prioridade_nome UNIQUE (nome_prioridade)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS status_demanda (
    id_status   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_status VARCHAR(80) NOT NULL,
    descricao   VARCHAR(255) NULL,
    PRIMARY KEY (id_status),
    CONSTRAINT uq_status_demanda_nome UNIQUE (nome_status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS demanda (
    id_demanda          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    numero_protocolo    VARCHAR(50) NOT NULL,
    titulo              VARCHAR(180) NOT NULL,
    descricao           TEXT NOT NULL,
    local_solicitacao   VARCHAR(255) NOT NULL,
    contato_solicitacao VARCHAR(100) NULL,
    id_comunidade       BIGINT UNSIGNED NOT NULL,
    id_cidadao          BIGINT UNSIGNED NOT NULL,
    id_categoria        BIGINT UNSIGNED NOT NULL,
    id_prioridade       BIGINT UNSIGNED NOT NULL,
    data_solicitacao    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_atual        BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_demanda),
    CONSTRAINT uq_demanda_protocolo UNIQUE (numero_protocolo),
    CONSTRAINT fk_demanda_comunidade
      FOREIGN KEY (id_comunidade) REFERENCES comunidade (id_comunidade)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_demanda_cidadao
      FOREIGN KEY (id_cidadao) REFERENCES cidadao (id_usuario)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_demanda_categoria
      FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_demanda_prioridade
      FOREIGN KEY (id_prioridade) REFERENCES prioridade (id_prioridade)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_demanda_status
      FOREIGN KEY (status_atual) REFERENCES status_demanda (id_status)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_demanda_comunidade (id_comunidade),
    INDEX idx_demanda_cidadao (id_cidadao),
    INDEX idx_demanda_categoria (id_categoria),
    INDEX idx_demanda_prioridade (id_prioridade),
    INDEX idx_demanda_status_data (status_atual, data_solicitacao),
    INDEX idx_demanda_data (data_solicitacao)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS historico_demanda (
    id_historico    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_demanda      BIGINT UNSIGNED NOT NULL,
    id_usuario      BIGINT UNSIGNED NOT NULL,
    data_hora       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    acao_realizada  VARCHAR(150) NOT NULL,
    descricao       TEXT NULL,
    anexo           TEXT NULL,
    PRIMARY KEY (id_historico),
    CONSTRAINT fk_historico_demanda
      FOREIGN KEY (id_demanda) REFERENCES demanda (id_demanda)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_historico_usuario
      FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_historico_demanda_data (id_demanda, data_hora),
    INDEX idx_historico_usuario (id_usuario)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS atribuicao (
    id_atribuicao  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_demanda     BIGINT UNSIGNED NOT NULL,
    id_usuario     BIGINT UNSIGNED NOT NULL,
    data_atribuicao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    prazo_previsto  DATETIME NULL,
    observacao      TEXT NULL,
    PRIMARY KEY (id_atribuicao),
    CONSTRAINT fk_atribuicao_demanda
      FOREIGN KEY (id_demanda) REFERENCES demanda (id_demanda)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_atribuicao_usuario
      FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_atribuicao_prazo
      CHECK (prazo_previsto IS NULL OR prazo_previsto >= data_atribuicao),
    INDEX idx_atribuicao_demanda (id_demanda),
    INDEX idx_atribuicao_usuario (id_usuario),
    INDEX idx_atribuicao_prazo (prazo_previsto)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS relatorio (
    id_relatorio   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    tipo_relatorio VARCHAR(100) NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fim    DATE NOT NULL,
    data_geracao   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    arquivo_url    VARCHAR(500) NULL,
    id_usuario     BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_relatorio),
    CONSTRAINT fk_relatorio_usuario
      FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_relatorio_periodo
      CHECK (periodo_fim >= periodo_inicio),
    INDEX idx_relatorio_usuario_data (id_usuario, data_geracao),
    INDEX idx_relatorio_periodo (periodo_inicio, periodo_fim)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS auditoria (
    id_auditoria   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_usuario     BIGINT UNSIGNED NULL,
    tabela_afetada VARCHAR(100) NOT NULL,
    registro_id    BIGINT UNSIGNED NOT NULL,
    acao           ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    data_hora      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_maquina     VARCHAR(45) NULL,
    PRIMARY KEY (id_auditoria),
    CONSTRAINT fk_auditoria_usuario
      FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_auditoria_usuario_data (id_usuario, data_hora),
    INDEX idx_auditoria_tabela_registro (tabela_afetada, registro_id),
    INDEX idx_auditoria_data (data_hora)
) ENGINE=InnoDB;

DROP TRIGGER IF EXISTS trg_demanda_gerar_protocolo;
DELIMITER $$
CREATE TRIGGER trg_demanda_gerar_protocolo
BEFORE INSERT ON demanda
FOR EACH ROW
BEGIN
    IF NEW.numero_protocolo IS NULL OR TRIM(NEW.numero_protocolo) = '' THEN
        SET NEW.numero_protocolo = CONCAT(
            'ELOS-',
            DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m%d'),
            '-',
            UPPER(REPLACE(UUID(), '-', ''))
        );
    END IF;
END$$
DELIMITER ;

INSERT IGNORE INTO status_demanda (nome_status, descricao) VALUES
('Pendente', 'Solicitação registrada e aguardando análise da empresa.'),
('Em análise', 'A empresa está analisando as informações da solicitação.'),
('Aguardando informações', 'A comunidade precisa enviar informações adicionais.'),
('Aprovada', 'Solicitação aprovada para atendimento.'),
('Rejeitada', 'Solicitação rejeitada pela empresa.'),
('Em atendimento', 'Serviço aprovado e em execução.'),
('Concluída', 'Atendimento concluído e resultado registrado.'),
('Encerrada', 'Solicitação encerrada e histórico arquivado.');
