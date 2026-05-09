-- ============================================================
-- StudyMatch — Script 01: Schema PostgreSQL
-- Bases de Datos II — 2025
-- ============================================================

-- Extensiones
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- TABLA: usuario
-- ============================================================
CREATE TABLE usuario (
    id_usuario    SERIAL          PRIMARY KEY,
    nombre        VARCHAR(120)    NOT NULL,
    email         VARCHAR(255)    NOT NULL UNIQUE,
    contrasenia   VARCHAR(255)    NOT NULL,  -- hash bcrypt
    idioma        VARCHAR(50)     NOT NULL DEFAULT 'español',
    estado        VARCHAR(20)     NOT NULL DEFAULT 'activo'
                  CHECK (estado IN ('activo', 'inactivo', 'suspendido')),
    fecha_registro TIMESTAMP      NOT NULL DEFAULT NOW(),
    ultimo_acceso  TIMESTAMP
);

-- ============================================================
-- TABLA: tema
-- ============================================================
CREATE TABLE tema (
    id_tema       SERIAL          PRIMARY KEY,
    nombre        VARCHAR(150)    NOT NULL UNIQUE,
    descripcion   TEXT,
    alias         TEXT[]          -- Array de nombres alternativos
);

-- ============================================================
-- TABLA: horario
-- ============================================================
CREATE TABLE horario (
    id_horario    SERIAL          PRIMARY KEY,
    dia           VARCHAR(15)     NOT NULL
                  CHECK (dia IN ('lunes','martes','miercoles','jueves','viernes','sabado','domingo')),
    hora_inicio   TIME            NOT NULL,
    hora_fin      TIME            NOT NULL,
    CHECK (hora_fin > hora_inicio)
);

-- ============================================================
-- TABLA: usuario_tema (relación N:M)
-- ============================================================
CREATE TABLE usuario_tema (
    id_usuario    INT             NOT NULL REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    id_tema       INT             NOT NULL REFERENCES tema(id_tema) ON DELETE CASCADE,
    nivel         VARCHAR(20)     NOT NULL
                  CHECK (nivel IN ('basico', 'intermedio', 'avanzado')),
    fecha_agregado TIMESTAMP      NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id_usuario, id_tema)
);

-- ============================================================
-- TABLA: usuario_horario (relación N:M)
-- ============================================================
CREATE TABLE usuario_horario (
    id_usuario    INT             NOT NULL REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    id_horario    INT             NOT NULL REFERENCES horario(id_horario) ON DELETE CASCADE,
    PRIMARY KEY (id_usuario, id_horario)
);

-- ============================================================
-- TABLA: match
-- ============================================================
CREATE TABLE match (
    id_match          SERIAL          PRIMARY KEY,
    id_usuario_a      INT             NOT NULL REFERENCES usuario(id_usuario),
    id_usuario_b      INT             NOT NULL REFERENCES usuario(id_usuario),
    id_tema           INT             NOT NULL REFERENCES tema(id_tema),
    estado            VARCHAR(20)     NOT NULL DEFAULT 'pendiente'
                      CHECK (estado IN ('pendiente', 'aceptado', 'rechazado', 'finalizado')),
    puntaje_compatibilidad INT        NOT NULL DEFAULT 0
                      CHECK (puntaje_compatibilidad BETWEEN 0 AND 100),
    fecha_creacion    TIMESTAMP       NOT NULL DEFAULT NOW(),
    fecha_actualizacion TIMESTAMP,
    -- RN-02: no auto-match
    CHECK (id_usuario_a != id_usuario_b)
);

-- Unicidad: no dos matches activos entre el mismo par para el mismo tema
CREATE UNIQUE INDEX idx_match_unico
ON match (
    LEAST(id_usuario_a, id_usuario_b),
    GREATEST(id_usuario_a, id_usuario_b),
    id_tema
)
WHERE estado IN ('pendiente', 'aceptado');

-- ============================================================
-- TABLA: mensaje
-- ============================================================
CREATE TABLE mensaje (
    id_mensaje    SERIAL          PRIMARY KEY,
    id_match      INT             NOT NULL REFERENCES match(id_match) ON DELETE CASCADE,
    id_emisor     INT             NOT NULL REFERENCES usuario(id_usuario),
    contenido     TEXT            NOT NULL,
    fecha_envio   TIMESTAMP       NOT NULL DEFAULT NOW(),
    leido         BOOLEAN         NOT NULL DEFAULT FALSE
);
