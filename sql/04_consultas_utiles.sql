-- ============================================================
-- StudyMatch — Script 04: Consultas útiles
-- Bases de Datos II — 2025
-- ============================================================

-- 1. Ver todos los temas de un usuario con su nivel
SELECT t.nombre, ut.nivel, ut.fecha_agregado
FROM usuario_tema ut
JOIN tema t ON t.id_tema = ut.id_tema
WHERE ut.id_usuario = 1;

-- 2. Ver todos los matches activos de un usuario
SELECT
  u.nombre AS compañero,
  t.nombre AS tema,
  m.estado,
  m.puntaje_compatibilidad,
  m.fecha_creacion
FROM match m
JOIN usuario u ON u.id_usuario =
  CASE WHEN m.id_usuario_a = 1 THEN m.id_usuario_b ELSE m.id_usuario_a END
JOIN tema t ON t.id_tema = m.id_tema
WHERE (m.id_usuario_a = 1 OR m.id_usuario_b = 1)
  AND m.estado IN ('pendiente', 'aceptado')
ORDER BY m.fecha_creacion DESC;

-- 3. Algoritmo de matching simplificado para usuario 1
SELECT
  u.id_usuario,
  u.nombre,
  u.idioma,
  COUNT(DISTINCT ut_b.id_tema) AS temas_comunes,
  (COUNT(DISTINCT ut_b.id_tema) * 50 +
   COUNT(DISTINCT CASE WHEN ut_a.nivel = ut_b.nivel THEN ut_b.id_tema END) * 20)
   AS puntaje
FROM usuario u
JOIN usuario_tema ut_b ON u.id_usuario = ut_b.id_usuario
JOIN usuario_tema ut_a ON ut_a.id_tema = ut_b.id_tema
WHERE ut_a.id_usuario = 1
  AND u.id_usuario != 1
  AND u.estado = 'activo'
GROUP BY u.id_usuario, u.nombre, u.idioma
HAVING (COUNT(DISTINCT ut_b.id_tema) * 50) >= 50  -- al menos un tema común
ORDER BY puntaje DESC;

-- 4. Horarios en común entre dos usuarios
SELECT h.dia, h.hora_inicio, h.hora_fin
FROM usuario_horario uh_a
JOIN usuario_horario uh_b ON uh_a.id_horario = uh_b.id_horario
JOIN horario h ON h.id_horario = uh_a.id_horario
WHERE uh_a.id_usuario = 1
  AND uh_b.id_usuario = 2
ORDER BY h.dia, h.hora_inicio;

-- 5. Ver chat de un match
SELECT
  u.nombre AS emisor,
  m.contenido,
  m.fecha_envio,
  m.leido
FROM mensaje m
JOIN usuario u ON u.id_usuario = m.id_emisor
WHERE m.id_match = 1
ORDER BY m.fecha_envio ASC;

-- 6. Cantidad de matches activos por usuario (para chequear RN-09)
SELECT
  u.nombre,
  COUNT(*) AS matches_activos
FROM match m
JOIN usuario u ON u.id_usuario = m.id_usuario_a OR u.id_usuario = m.id_usuario_b
WHERE m.estado IN ('pendiente', 'aceptado')
  AND (u.id_usuario = m.id_usuario_a OR u.id_usuario = m.id_usuario_b)
GROUP BY u.id_usuario, u.nombre
HAVING COUNT(*) >= 8  -- usuarios cerca del límite (10)
ORDER BY matches_activos DESC;

-- 7. Temas más populares
SELECT t.nombre, COUNT(*) AS cantidad_usuarios
FROM usuario_tema ut
JOIN tema t ON t.id_tema = ut.id_tema
GROUP BY t.nombre
ORDER BY cantidad_usuarios DESC;
