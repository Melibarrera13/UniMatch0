# 📏 Reglas de Negocio — StudyMatch

## RN-01: Unicidad de email
- El email de cada usuario debe ser único en el sistema.
- No se permite registrar dos cuentas con el mismo email.

## RN-02: Auto-match prohibido
- Un usuario NO puede hacer match consigo mismo.
- El sistema debe validar que `usuario_solicitante != usuario_receptor`.

## RN-03: Match único por par
- No pueden existir dos matches activos entre los mismos dos usuarios para el mismo tema.
- Se permite un nuevo match si el anterior fue rechazado o finalizado.

## RN-04: Requisito horario mínimo
- Para que un match sea válido, los dos usuarios deben compartir al menos **1 bloque horario en común**.
- Un bloque horario = franja de 1 hora dentro de los días disponibles declarados.

## RN-05: Chat habilitado solo con match aceptado
- Los mensajes entre dos usuarios solo se habilitan si el match está en estado `aceptado`.
- No se pueden enviar mensajes con match en estado `pendiente` o `rechazado`.

## RN-06: Estados del match
- Un match solo puede transitar entre los siguientes estados:
  ```
  pendiente → aceptado
  pendiente → rechazado
  aceptado  → finalizado
  ```
- No se puede pasar de `rechazado` a `aceptado` directamente.

## RN-07: Temas con alias
- Un tema puede tener múltiples nombres alternativos (alias).
- El sistema debe normalizar la búsqueda considerando todos los alias.
- Ejemplo: "BD", "Base de datos", "Bases de datos" → mismo tema.

## RN-08: Nivel requerido en tema
- Cuando un usuario agrega un tema, debe especificar su nivel: `basico`, `intermedio` o `avanzado`.
- No se puede agregar un tema sin nivel.

## RN-09: Máximo de matches activos
- Un usuario puede tener como máximo **10 matches activos simultáneamente**.
- Al alcanzar el límite, el sistema rechaza nuevos matches hasta que se libere alguno.
- (El plan premium puede ampliar este límite a 25).

## RN-10: Contraseña segura
- La contraseña debe tener mínimo 8 caracteres.
- Debe contener al menos una mayúscula y un número.
- Se almacena siempre hasheada (bcrypt, nunca en texto plano).

## RN-11: Inactividad de usuario
- Un usuario inactivo por más de 90 días es marcado como `inactivo`.
- Los usuarios inactivos no aparecen en los resultados de matching.

## RN-12: Idioma del match
- El match solo se realiza entre usuarios que comparten al menos un idioma en común.
