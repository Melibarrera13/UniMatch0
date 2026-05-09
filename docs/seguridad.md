# 🔒 Seguridad — StudyMatch

## Autenticación

- **JWT (JSON Web Token):** cada sesión genera un token firmado con clave secreta
- El token incluye: `id_usuario`, `email`, `rol`, `exp` (expiración: 24hs)
- El token se almacena en Redis con TTL para permitir cierre de sesión forzado

## Contraseñas

- Almacenadas con **bcrypt** (factor de costo: 10)
- Nunca se almacenan en texto plano
- Nunca se devuelven en ninguna respuesta de la API

```javascript
// Ejemplo de hash con bcrypt
const hash = await bcrypt.hash(password, 10);
```

## Comunicación

- Toda comunicación cliente-servidor por **HTTPS**
- Certificado TLS/SSL obligatorio en producción
- WebSockets también sobre WSS (WebSocket Secure)

## Protección de datos

- Los mensajes se almacenan referenciando solo el `id_match`
- No se expone el email de otros usuarios en la API de matching
- El perfil público muestra solo: nombre, temas, nivel, idiomas (no email ni contraseña)

## Rate Limiting

- Máximo 100 requests por minuto por IP
- Máximo 10 intentos de login fallidos → bloqueo temporal de 15 minutos
- Implementado con middleware en Express + Redis como contador

## Validaciones de entrada

- Sanitización de todos los inputs antes de consultas SQL
- Uso de **prepared statements** (nunca concatenación directa en SQL)
- Validación de tipos con `express-validator`

## Roles

| Rol | Acceso |
|---|---|
| `estudiante` | Acceso a su propio perfil, matches, mensajes |
| `admin` | Gestión de temas, usuarios, reportes |

## Próximas mejoras de seguridad (roadmap)

- 2FA (autenticación de dos factores)
- Auditoría de acciones sensibles (login, cambio de email)
- GDPR: borrado de cuenta y exportación de datos personales
