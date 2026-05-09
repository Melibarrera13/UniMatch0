-- ============================================================
-- StudyMatch — Script 03: Datos Demo
-- Bases de Datos II — 2025
-- ============================================================

-- USUARIOS (contraseñas hasheadas con bcrypt)
INSERT INTO usuario (nombre, email, contrasenia, idioma) VALUES
('Laura Gómez',    'laura@demo.com',   '$2b$10$hash_demo_1', 'español'),
('Matías López',   'matias@demo.com',  '$2b$10$hash_demo_2', 'español'),
('Carolina Ruiz',  'caro@demo.com',    '$2b$10$hash_demo_3', 'español'),
('Bruno Martínez', 'bruno@demo.com',   '$2b$10$hash_demo_4', 'español'),
('Valentina Cruz', 'vale@demo.com',    '$2b$10$hash_demo_5', 'español');

-- TEMAS
INSERT INTO tema (nombre, descripcion, alias) VALUES
('Normalización',      'Formas normales en bases de datos relacionales', ARRAY['Normalizacion','Normal Forms','NF']),
('Álgebra Relacional', 'Operaciones del modelo relacional',              ARRAY['Algebra Relacional','RA']),
('SQL Avanzado',       'Subconsultas, joins, window functions',          ARRAY['SQL','Structured Query Language']),
('Transacciones',      'ACID, concurrencia y control',                  ARRAY['Transactions','ACID']),
('Neo4j / Grafos',     'Bases de datos orientadas a grafos',            ARRAY['Graph DB','Neo4j','Cypher']);

-- HORARIOS
INSERT INTO horario (dia, hora_inicio, hora_fin) VALUES
('lunes',    '18:00', '20:00'),
('lunes',    '20:00', '22:00'),
('martes',   '18:00', '20:00'),
('miercoles','17:00', '19:00'),
('jueves',   '19:00', '21:00'),
('sabado',   '10:00', '12:00'),
('sabado',   '14:00', '16:00');

-- USUARIO_TEMA
INSERT INTO usuario_tema (id_usuario, id_tema, nivel) VALUES
(1, 1, 'intermedio'),  -- Laura estudia Normalización
(1, 3, 'basico'),      -- Laura estudia SQL Avanzado
(2, 1, 'intermedio'),  -- Matías estudia Normalización
(2, 4, 'avanzado'),    -- Matías estudia Transacciones
(3, 1, 'avanzado'),    -- Carolina estudia Normalización
(3, 2, 'intermedio'),  -- Carolina estudia Álgebra Relacional
(4, 3, 'basico'),      -- Bruno estudia SQL Avanzado
(4, 5, 'intermedio'),  -- Bruno estudia Neo4j
(5, 2, 'intermedio'),  -- Valentina estudia Álgebra Relacional
(5, 4, 'intermedio');  -- Valentina estudia Transacciones

-- USUARIO_HORARIO
INSERT INTO usuario_horario (id_usuario, id_horario) VALUES
(1, 1), (1, 3),  -- Laura: lunes 18-20, martes 18-20
(2, 1), (2, 5),  -- Matías: lunes 18-20, jueves 19-21
(3, 3), (3, 4),  -- Carolina: martes 18-20, miércoles 17-19
(4, 6), (4, 7),  -- Bruno: sábado mañana y tarde
(5, 1), (5, 5);  -- Valentina: lunes 18-20, jueves 19-21

-- MATCH de ejemplo
INSERT INTO match (id_usuario_a, id_usuario_b, id_tema, estado, puntaje_compatibilidad) VALUES
(1, 2, 1, 'aceptado', 90),  -- Laura + Matías, Normalización
(2, 5, 4, 'pendiente', 70); -- Matías + Valentina, Transacciones

-- MENSAJES de ejemplo (solo del match aceptado)
INSERT INTO mensaje (id_match, id_emisor, contenido) VALUES
(1, 1, 'Hola Matías! ¿Podemos estudiar el lunes a las 18?'),
(1, 2, 'Sí, perfecto! Nos vemos en la biblioteca.');
