# 📐 Modelo Entidad-Relación — StudyMatch

## Diagrama (notación texto)

```
┌──────────────┐        ┌─────────────────┐        ┌──────────────┐
│   USUARIO    │        │  USUARIO_TEMA   │        │    TEMA      │
│──────────────│        │─────────────────│        │──────────────│
│ PK id_usuario│─────── │ FK id_usuario   │ ───────│ PK id_tema   │
│    nombre    │  1   N │ FK id_tema      │ N   1  │    nombre    │
│    email     │        │    nivel        │        │    alias[]   │
│    contraseña│        │    fecha_agr.   │        │    descripcion│
│    idioma    │        └─────────────────┘        └──────────────┘
│    estado    │
│    fecha_reg.│        ┌─────────────────┐        ┌──────────────┐
└──────┬───────┘        │ USUARIO_HORARIO │        │   HORARIO    │
       │                │─────────────────│        │──────────────│
       │                │ FK id_usuario   │        │ PK id_horario│
       │─────────────── │ FK id_horario   │ ───────│    dia       │
              1   N     │                 │ N   1  │    hora_inicio│
                        └─────────────────┘        │    hora_fin  │
                                                    └──────────────┘

┌──────────────────────────────────────────────────────┐
│                       MATCH                          │
│──────────────────────────────────────────────────────│
│ PK id_match                                          │
│ FK id_usuario_a ────────────────────── → USUARIO     │
│ FK id_usuario_b ────────────────────── → USUARIO     │
│ FK id_tema      ────────────────────── → TEMA        │
│    estado       (pendiente/aceptado/rechazado/final.) │
│    puntaje_compatibilidad                            │
│    fecha_creacion                                    │
└──────────────────────────────────────┬───────────────┘
                                       │ 1
                                       │
                                       │ N
                              ┌────────┴───────┐
                              │    MENSAJE     │
                              │────────────────│
                              │ PK id_mensaje  │
                              │ FK id_match    │
                              │ FK id_emisor   │
                              │    contenido   │
                              │    fecha_envio │
                              │    leido       │
                              └────────────────┘
```

## Cardinalidades

| Relación | Cardinalidad | Descripción |
|---|---|---|
| USUARIO — TEMA | N:M (via USUARIO_TEMA) | Un usuario puede tener muchos temas; un tema puede tener muchos usuarios |
| USUARIO — HORARIO | N:M (via USUARIO_HORARIO) | Un usuario puede tener muchos horarios |
| USUARIO — MATCH | 1:N (x2) | Un usuario puede tener muchos matches (como A o como B) |
| MATCH — MENSAJE | 1:N | Un match puede tener muchos mensajes |
| USUARIO — MENSAJE | 1:N | Un usuario puede emitir muchos mensajes |

## Restricciones clave del modelo

- `email` en USUARIO: `UNIQUE NOT NULL`
- `(id_usuario, id_tema)` en USUARIO_TEMA: `PRIMARY KEY`
- `id_usuario_a != id_usuario_b` en MATCH: `CHECK`
- No pueden existir dos matches activos entre el mismo par y tema: `UNIQUE INDEX` condicional
