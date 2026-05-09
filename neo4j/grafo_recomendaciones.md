# 🕸️ Neo4j — Grafo de Recomendaciones

## ¿Por qué Neo4j?

Las consultas del tipo "personas que estudiaron con tus compañeros" son costosas en SQL (múltiples JOINs recursivos). En Neo4j se expresan con una sola query Cypher en milisegundos.

---

## Modelo del grafo

### Nodos
- `(u:Usuario {id, nombre})`
- `(t:Tema {id, nombre})`

### Relaciones
- `(u1)-[:ESTUDIO_CON {fecha, puntaje}]->(u2)` — match aceptado
- `(u)-[:INTERESADO_EN {nivel}]->(t)` — usuario_tema

---

## Crear nodos y relaciones (Cypher)

```cypher
// Crear usuario
CREATE (u:Usuario {id: 1, nombre: 'Laura Gómez'})

// Crear tema
CREATE (t:Tema {id: 1, nombre: 'Normalización'})

// Laura interesada en Normalización
MATCH (u:Usuario {id: 1}), (t:Tema {id: 1})
CREATE (u)-[:INTERESADO_EN {nivel: 'intermedio'}]->(t)

// Match aceptado entre Laura y Matías
MATCH (a:Usuario {id: 1}), (b:Usuario {id: 2})
CREATE (a)-[:ESTUDIO_CON {fecha: date(), puntaje: 90}]->(b)
```

---

## Queries de recomendación

### "Personas que estudian lo mismo que yo"
```cypher
MATCH (yo:Usuario {id: $id_usuario})-[:INTERESADO_EN]->(t:Tema)
      <-[:INTERESADO_EN]-(otro:Usuario)
WHERE otro.id <> yo.id
RETURN otro.nombre, t.nombre, COUNT(t) AS temas_comunes
ORDER BY temas_comunes DESC
LIMIT 10
```

### "Amigos de mis compañeros de estudio" (recomendación social)
```cypher
MATCH (yo:Usuario {id: $id_usuario})-[:ESTUDIO_CON]->(conocido:Usuario)
      -[:ESTUDIO_CON]->(sugerido:Usuario)
WHERE sugerido.id <> yo.id
  AND NOT (yo)-[:ESTUDIO_CON]->(sugerido)
RETURN sugerido.nombre, COUNT(conocido) AS conexiones_en_comun
ORDER BY conexiones_en_comun DESC
LIMIT 5
```

### "¿Qué temas estudia mi red?"
```cypher
MATCH (yo:Usuario {id: $id_usuario})-[:ESTUDIO_CON*1..2]-(red:Usuario)
      -[:INTERESADO_EN]->(t:Tema)
WHERE NOT (yo)-[:INTERESADO_EN]->(t)
RETURN t.nombre, COUNT(red) AS popularidad
ORDER BY popularidad DESC
LIMIT 5
```

---

## Sincronización con PostgreSQL

Cuando en PostgreSQL:
- Se acepta un match → se crea relación `ESTUDIO_CON` en Neo4j
- Se agrega un tema → se crea relación `INTERESADO_EN` en Neo4j
- Se elimina un usuario → se eliminan sus nodos en Neo4j

Esta sincronización la realiza el backend (no hay comunicación directa entre las BDs).
