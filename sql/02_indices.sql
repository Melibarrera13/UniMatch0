-- ============================================================
-- StudyMatch — Script 02: Índices y Optimización
-- Bases de Datos II — 2025
-- ============================================================

-- El algoritmo de matching busca temas constantemente
CREATE INDEX idx_usuario_tema_tema
ON usuario_tema(id_tema);

-- Búsqueda de todos los temas de un usuario
CREATE INDEX idx_usuario_tema_usuario
ON usuario_tema(id_usuario);

-- Búsqueda de matches por usuario (ambas direcciones)
CREATE INDEX idx_match_usuario_a
ON match(id_usuario_a);

CREATE INDEX idx_match_usuario_b
ON match(id_usuario_b);

-- Filtrar matches por estado (muy frecuente)
CREATE INDEX idx_match_estado
ON match(estado);

-- Mensajes de un match (chat)
CREATE INDEX idx_mensaje_match
ON mensaje(id_match, fecha_envio DESC);

-- Mensajes no leídos de un usuario
CREATE INDEX idx_mensaje_no_leido
ON mensaje(id_emisor, leido)
WHERE leido = FALSE;

-- Búsqueda de usuarios activos
CREATE INDEX idx_usuario_estado
ON usuario(estado)
WHERE estado = 'activo';

-- Búsqueda de usuarios por email (login)
-- Ya cubierto por la restricción UNIQUE, pero documentamos:
-- CREATE UNIQUE INDEX idx_usuario_email ON usuario(email); -- implícito

-- Horarios de un usuario
CREATE INDEX idx_usuario_horario_usuario
ON usuario_horario(id_usuario);

-- ============================================================
-- COMENTARIO SOBRE OPTIMIZACIÓN
-- ============================================================
-- El índice más crítico es idx_usuario_tema_tema.
-- El algoritmo de matching itera sobre todos los usuarios
-- que tienen un tema determinado, por lo que este índice
-- reduce el costo de O(n) a O(log n) + filas relevantes.
-- ============================================================
