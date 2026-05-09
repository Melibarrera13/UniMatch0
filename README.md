# 📚 StudyMatch — Bases de Datos II

Sistema de matching entre estudiantes universitarios para formación de grupos de estudio, basado en temas, niveles y disponibilidad horaria.

## 🗂️ Estructura del repositorio

```
proyecto-bdii/
├── docs/
│   ├── caso_de_estudio.md
│   ├── reglas_de_negocio.md
│   ├── casos_de_uso.md
│   ├── algoritmo_matching.md
│   ├── arquitectura.md
│   └── seguridad.md
├── sql/
│   ├── 01_schema.sql
│   ├── 02_indices.sql
│   ├── 03_datos_demo.sql
│   └── 04_consultas_utiles.sql
├── redis/
│   └── estructura_cache.md
├── neo4j/
│   └── grafo_recomendaciones.md
├── api/
│   └── endpoints.md
├── diagramas/
│   └── MER.md
└── README.md
```

## 🛠️ Stack Tecnológico (Modelo Políglota)

| Base de Datos | Uso | Justificación |
|---|---|---|
| **PostgreSQL** | Datos relacionales, usuarios, matches | Integridad referencial, ACID |
| **Redis** | Caché de sesiones y horarios | Alta velocidad de lectura |
| **Neo4j** | Grafo de recomendaciones | Traversal eficiente entre nodos |

## 🚀 Cómo inicializar

```bash
# PostgreSQL
psql -U postgres -f sql/01_schema.sql
psql -U postgres -f sql/02_indices.sql
psql -U postgres -f sql/03_datos_demo.sql
```

## 👥 Integrantes

- [Nombre 1]
- [Nombre 2]
- [Nombre 3]

## 📅 Universidad — Año 2025
