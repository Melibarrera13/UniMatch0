# 🌐 API REST — Endpoints

**Base URL:** `https://api.studymatch.com/v1`  
**Autenticación:** Bearer Token (JWT) en el header `Authorization`

---

## Usuarios

### `POST /usuarios` — Registrar usuario
**Body:**
```json
{
  "nombre": "Laura Gómez",
  "email": "laura@demo.com",
  "contrasenia": "Segura123",
  "idioma": "español"
}
```
**Respuesta exitosa (201):**
```json
{ "id_usuario": 1, "token": "eyJhbGci..." }
```

### `POST /usuarios/login` — Iniciar sesión
**Body:**
```json
{ "email": "laura@demo.com", "contrasenia": "Segura123" }
```
**Respuesta exitosa (200):**
```json
{ "token": "eyJhbGci...", "usuario": { "id": 1, "nombre": "Laura Gómez" } }
```

### `GET /usuarios/perfil` — Ver mi perfil *(auth)*
**Respuesta:** datos del usuario autenticado (sin contraseña)

### `PUT /usuarios/perfil` — Actualizar perfil *(auth)*

---

## Temas

### `GET /temas` — Listar todos los temas
Parámetros opcionales: `?buscar=normal` (filtra por nombre o alias)

### `POST /usuarios/temas` — Agregar tema a mi perfil *(auth)*
```json
{ "id_tema": 1, "nivel": "intermedio" }
```

### `DELETE /usuarios/temas/{id_tema}` — Eliminar tema de mi perfil *(auth)*

---

## Matching

### `GET /matching` — Obtener candidatos compatibles *(auth)*
Retorna lista ordenada por puntaje de compatibilidad.

**Respuesta:**
```json
[
  {
    "id_usuario": 2,
    "nombre": "Matías López",
    "temas_comunes": ["Normalización"],
    "puntaje": 90,
    "horarios_comunes": [{"dia":"lunes","hora_inicio":"18:00","hora_fin":"20:00"}]
  }
]
```

---

## Matches

### `POST /matches` — Solicitar match *(auth)*
```json
{ "id_usuario_b": 2, "id_tema": 1 }
```

### `GET /matches` — Ver mis matches *(auth)*
Parámetros: `?estado=aceptado` | `pendiente` | `rechazado` | `finalizado`

### `PUT /matches/{id_match}` — Responder a un match *(auth)*
```json
{ "accion": "aceptar" }   // o "rechazar"
```

---

## Mensajes

### `GET /matches/{id_match}/mensajes` — Ver chat *(auth)*
Solo disponible si el match está en estado `aceptado`.

### `POST /matches/{id_match}/mensajes` — Enviar mensaje *(auth)*
```json
{ "contenido": "Hola! ¿Estudiamos el lunes?" }
```

---

## Horarios

### `POST /usuarios/horarios` — Agregar disponibilidad *(auth)*
```json
{ "dia": "lunes", "hora_inicio": "18:00", "hora_fin": "20:00" }
```

### `DELETE /usuarios/horarios/{id_horario}` — Eliminar disponibilidad *(auth)*

---

## Códigos de error

| Código | Significado |
|---|---|
| 400 | Datos inválidos |
| 401 | No autenticado |
| 403 | Sin permiso |
| 404 | Recurso no encontrado |
| 409 | Conflicto (email duplicado, match ya existente) |
| 429 | Demasiadas solicitudes (rate limit) |
| 500 | Error interno del servidor |
