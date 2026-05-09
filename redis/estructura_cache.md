# ⚡ Redis — Estructura de Caché

## ¿Por qué Redis?

Las consultas de horarios disponibles se ejecutan miles de veces por minuto durante el algoritmo de matching. Redis permite leerlas en microsegundos en lugar de milisegundos (consulta a PostgreSQL).

---

## Claves y estructuras

### Sesiones de usuario
```
KEY:   session:{id_usuario}
TYPE:  String (JWT token)
TTL:   86400 segundos (24 horas)
```

### Horarios disponibles por usuario
```
KEY:   horarios:{id_usuario}
TYPE:  Set
VALOR: "lunes-18:00-20:00", "martes-18:00-20:00", ...
TTL:   1800 segundos (30 minutos)
```

### Temas de un usuario (caché del matching)
```
KEY:   temas:{id_usuario}
TYPE:  Hash
CAMPO: {id_tema} → nivel
TTL:   900 segundos (15 minutos)
```

### Intentos fallidos de login (rate limiting)
```
KEY:   login_intentos:{email}
TYPE:  Counter (INCR)
TTL:   900 segundos (15 minutos)
LÓGICA: Si valor >= 10 → bloquear nuevos intentos
```

### Notificaciones pendientes
```
KEY:   notif:{id_usuario}
TYPE:  List (LPUSH / RPOP)
VALOR: JSON con tipo y datos del evento
TTL:   Sin TTL (persistente hasta que se consumen)
```

---

## Ejemplo de flujo: caché de horarios

```
1. Usuario A solicita matching
2. Backend consulta Redis: GET horarios:1
3. Si HIT → usa datos de Redis (rápido)
4. Si MISS → consulta PostgreSQL → guarda en Redis → usa datos
5. Cuando usuario actualiza horarios → DEL horarios:1 (invalida caché)
```

---

## Comandos Redis de ejemplo

```bash
# Ver sesión activa
GET session:1

# Ver horarios cacheados
SMEMBERS horarios:1

# Contar intentos de login fallidos
GET login_intentos:laura@demo.com

# Ver notificaciones pendientes
LRANGE notif:1 0 -1
```
