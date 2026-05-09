# 🧮 Algoritmo de Matching — UniMatch

## Objetivo

Dado un usuario A, calcular un puntaje de compatibilidad con cada usuario B disponible, y retornar los mejores candidatos ordenados de mayor a menor puntaje.

---

## Criterios de puntuación

| Criterio | Puntos | Descripción |
|---|---|---|
| Mismo tema | +50 | Comparten al menos 1 tema en común |
| Mismo nivel en ese tema | +20 | El nivel declarado es idéntico |
| Horario compatible | +20 | Al menos 1 bloque horario coincide |
| Mismo idioma | +10 | Comparten al menos 1 idioma |
| **Total máximo** | **100** | — |

**Umbral mínimo para generar match:** `puntaje >= 70`

---

## Algoritmo paso a paso

```
FUNCIÓN calcularCompatibilidad(usuarioA, usuarioB):

  puntaje = 0
  temasComunes = intersección(temas(A), temas(B))

  SI temasComunes está vacío:
    RETORNAR 0  // No tiene sentido sin tema común

  puntaje += 50  // Por tener temas en común

  PARA CADA tema EN temasComunes:
    SI nivel(A, tema) == nivel(B, tema):
      puntaje += 20
      BREAK  // Se suma una sola vez

  horarioComun = intersección(horarios(A), horarios(B))
  SI horarioComun no está vacío:
    puntaje += 20

  idiomaComun = intersección(idiomas(A), idiomas(B))
  SI idiomaComun no está vacío:
    puntaje += 10

  RETORNAR puntaje
```

---

## Ejemplo real

**Usuario A:** quiere estudiar "Normalización", nivel Intermedio, disponible Lunes 18-20hs, habla español.

**Usuario B:** estudia "Normalización", nivel Intermedio, disponible Lunes 19-21hs, habla español.

| Criterio | Resultado | Puntos |
|---|---|---|
| Mismo tema (Normalización) | ✅ | +50 |
| Mismo nivel (Intermedio) | ✅ | +20 |
| Horario compatible (Lunes 19-20hs) | ✅ | +20 |
| Mismo idioma (español) | ✅ | +10 |
| **Total** | | **100** |

✅ Puntaje 100 >= 70 → **match generado**

---

## Query SQL del algoritmo

```sql
SELECT
  u.id_usuario,
  u.nombre,
  COUNT(DISTINCT ut_b.id_tema) AS temas_comunes,
  -- Puntaje base
  (COUNT(DISTINCT ut_b.id_tema) * 50) +
  -- Bonus por nivel igual
  (COUNT(DISTINCT CASE WHEN ut_a.nivel = ut_b.nivel THEN ut_b.id_tema END) * 20)
  AS puntaje_parcial
FROM usuario u
JOIN usuario_tema ut_b ON u.id_usuario = ut_b.id_usuario
JOIN usuario_tema ut_a ON ut_a.id_tema = ut_b.id_tema
WHERE ut_a.id_usuario = :id_usuario_actual
  AND u.id_usuario != :id_usuario_actual
  AND u.estado = 'activo'
GROUP BY u.id_usuario, u.nombre
HAVING COUNT(DISTINCT ut_b.id_tema) > 0
ORDER BY puntaje_parcial DESC;
```

---

## Filtros previos al algoritmo (optimización)

Antes de calcular el puntaje, se excluyen:

1. Usuarios con match activo existente con A
2. Usuarios inactivos (estado != `activo`)
3. Usuarios sin ningún tema en común con A
4. Usuarios sin ningún horario en común con A

Esto reduce drásticamente el conjunto de candidatos antes de correr el algoritmo.
