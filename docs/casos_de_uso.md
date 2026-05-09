# 🎭 Casos de Uso — StudyMatch

---

## CU-01: Registrar usuario

**Actor:** Visitante  
**Precondición:** El email no debe estar registrado.

| Paso | Actor | Sistema |
|---|---|---|
| 1 | Ingresa nombre, email, contraseña, idioma | — |
| 2 | — | Valida formato de email |
| 3 | — | Verifica que el email no exista (RN-01) |
| 4 | — | Hashea la contraseña (RN-10) |
| 5 | — | Crea el usuario con estado `activo` |
| 6 | — | Retorna token JWT |

**Excepción:** Si el email ya existe → error 409 "Email ya registrado".

---

## CU-02: Agregar tema de interés

**Actor:** Usuario autenticado  
**Precondición:** El usuario debe estar logueado.

| Paso | Actor | Sistema |
|---|---|---|
| 1 | Busca tema por nombre | — |
| 2 | — | Busca en temas + alias (RN-07) |
| 3 | Selecciona tema y nivel | — |
| 4 | — | Valida que nivel sea válido (RN-08) |
| 5 | — | Inserta en `usuario_tema` |

---

## CU-03: Buscar matches

**Actor:** Usuario autenticado  
**Precondición:** El usuario tiene al menos un tema registrado.

| Paso | Actor | Sistema |
|---|---|---|
| 1 | Solicita buscar compañeros de estudio | — |
| 2 | — | Obtiene los temas del usuario |
| 3 | — | Busca usuarios con temas compatibles |
| 4 | — | Filtra por horarios en común (RN-04) |
| 5 | — | Aplica algoritmo de scoring (ver algoritmo_matching.md) |
| 6 | — | Retorna lista ordenada por puntaje |

---

## CU-04: Crear match

**Actor:** Usuario autenticado  
**Precondición:** El usuario encontró un candidato.

| Paso | Actor | Sistema |
|---|---|---|
| 1 | Selecciona candidato | — |
| 2 | — | Verifica que no sea auto-match (RN-02) |
| 3 | — | Verifica que no exista match activo entre ellos (RN-03) |
| 4 | — | Verifica límite de matches activos (RN-09) |
| 5 | — | Verifica compatibilidad horaria mínima (RN-04) |
| 6 | — | Crea match con estado `pendiente` |
| 7 | — | Notifica al receptor |

---

## CU-05: Aceptar / Rechazar match

**Actor:** Usuario receptor  
**Precondición:** Existe un match en estado `pendiente`.

| Paso | Actor | Sistema |
|---|---|---|
| 1 | Responde al match (acepta o rechaza) | — |
| 2 | — | Actualiza estado del match (RN-06) |
| 3 | — | Si aceptado → habilita chat (RN-05) |
| 4 | — | Notifica al solicitante |

---

## CU-06: Enviar mensaje

**Actor:** Usuario con match aceptado  
**Precondición:** El match entre los dos usuarios está en estado `aceptado`.

| Paso | Actor | Sistema |
|---|---|---|
| 1 | Escribe y envía mensaje | — |
| 2 | — | Verifica estado del match (RN-05) |
| 3 | — | Guarda mensaje con timestamp |
| 4 | — | Entrega al receptor |
