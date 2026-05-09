# 🏗️ Arquitectura del Sistema — StudyMatch

## Diagrama general

```
┌─────────────────────────────────┐
│         CLIENTE (Web/Móvil)     │
│     React / React Native        │
└──────────────┬──────────────────┘
               │ HTTPS
               ▼
┌─────────────────────────────────┐
│         API REST (Backend)      │
│         Node.js + Express       │
│         Puerto: 3000            │
└──────┬────────────┬─────────────┘
       │            │
       ▼            ▼
┌──────────┐  ┌──────────────────────────┐
│  Redis   │  │       PostgreSQL          │
│  Cache   │  │  Base de datos principal  │
│  :6379   │  │  Puerto: 5432             │
└──────────┘  └──────────────────────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │        Neo4j          │
              │  Grafo de relaciones  │
              │  Puerto: 7474 / 7687  │
              └───────────────────────┘
```

---

## Responsabilidades por capa

### Frontend
- Registro e inicio de sesión
- Gestión de temas y horarios
- Visualización de matches
- Chat en tiempo real (WebSocket)

### API Backend
- Autenticación con JWT
- Lógica de negocio y validaciones
- Orquestación entre las tres BDs
- Rate limiting

### PostgreSQL
- Persistencia de usuarios, temas, matches, mensajes
- Integridad referencial
- Consultas de matching base

### Redis
- Caché de sesiones (JWT activos)
- Caché de horarios disponibles por usuario
- TTL: 30 minutos para horarios, 24 horas para sesiones

### Neo4j
- Grafo de afinidad entre usuarios
- Recomendaciones por "amigos de amigos" (usuarios que estudian con personas que ya estudiaste)
- Query Cypher para sugerencias

---

## Flujo de un match

```
Usuario A solicita match
        │
        ▼
API valida JWT ──── Redis (verificar sesión)
        │
        ▼
Verifica reglas ─── PostgreSQL (RN-02, RN-03, RN-09)
        │
        ▼
Calcula scoring ─── PostgreSQL (algoritmo de matching)
        │
        ▼
Guarda match ─────── PostgreSQL (INSERT en MATCH)
        │
        ▼
Actualiza grafo ──── Neo4j (nueva relación entre nodos)
        │
        ▼
Notifica receptor
```

---

## Consideraciones de escalabilidad (conceptual)

- **Sharding horizontal** en PostgreSQL por `id_usuario` para escalar a millones de usuarios
- **Replicación** Redis con Redis Sentinel para alta disponibilidad del caché
- **Cluster Neo4j** para distribuir el grafo en múltiples instancias
- **Microservicios futuros:** separar servicio de matching, servicio de chat y servicio de usuarios
