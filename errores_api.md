# Catálogo Completo de Errores y Validaciones de la API — Ojos de Sol

Este documento describe de manera exhaustiva todos los mensajes de error generales y las validaciones de campos a nivel de negocio e interfaz de la API del sistema de monitoreo solar **Ojos de Sol**. Todos los errores devueltos por la API siguen estrictamente el estándar de la industria **RFC 9457 (Problem Details for HTTP APIs)** utilizando el Content-Type `application/problem+json`.

---

## 1. Estructura Estándar de Error (RFC 9457)

Cada respuesta de error devuelta por la API tendrá la siguiente estructura JSON básica:

| Campo | Tipo | Requerido | Descripción |
| :--- | :--- | :---: | :--- |
| `type` | String (URI) | Sí | URI de referencia único que identifica el tipo específico de error. |
| `title` | String | Sí | Título corto, legible para humanos, que resume el tipo de problema (generalmente asociado al código HTTP). |
| `status` | Integer | Sí | Código de estado HTTP correspondiente. |
| `detail` | String | Sí | Mensaje explicativo y específico sobre la ocurrencia actual del error. |
| `instance` | String (URI) | No | Ruta (URI relativo o absoluto) de la petición HTTP que causó el error. |
| `invalid_params` | Array | No | *(Extensión RFC 9457)* Lista de fallos de validación específicos por campo en solicitudes de creación o modificación (HTTP 400 o 422). |

---

## 2. Errores Generales del Sistema

### 400 Bad Request (Parámetros Inválidos o Mal Formados)
Se devuelve cuando la estructura del JSON es inválida (ej. error de sintaxis JSON) o cuando faltan campos mandatorios en el cuerpo de la petición.

```json
{
  "type": "https://api.ojosdesol.com/errors/bad-request",
  "title": "Petición Incorrecta",
  "status": 400,
  "detail": "El cuerpo de la solicitud no contiene un formato JSON válido o carece de campos obligatorios.",
  "instance": "/auth/register"
}
```

### 401 Unauthorized (Falta de Autenticación / Credenciales Incorrectas)
Se devuelve si el cliente no proporciona credenciales de acceso válidas (token JWT ausente, expirado o alterado), o si el flujo de login falla.

```json
{
  "type": "https://api.ojosdesol.com/errors/unauthorized",
  "title": "No Autorizado",
  "status": 401,
  "detail": "Las credenciales proporcionadas son incorrectas o el token de sesión ha expirado.",
  "instance": "/devices"
}
```

### 403 Forbidden (Permisos Insuficientes / Acción no Permitida)
Se devuelve cuando el usuario está autenticado pero su rol no posee los permisos requeridos en la matriz de acceso para el módulo o acción solicitada.

```json
{
  "type": "https://api.ojosdesol.com/errors/forbidden",
  "title": "Acceso Prohibido",
  "status": 403,
  "detail": "No tienes los permisos necesarios para realizar esta acción sobre el recurso solicitado.",
  "instance": "/users"
}
```

### 404 Not Found (Recurso no Encontrado)
Se genera cuando el identificador (`id` de usuario, dispositivo, alerta, horario) solicitado no existe en la base de datos.

```json
{
  "type": "https://api.ojosdesol.com/errors/not-found",
  "title": "Recurso no Encontrado",
  "status": 404,
  "detail": "El recurso solicitado no existe o ha sido eliminado.",
  "instance": "/devices/99"
}
```

### 409 Conflict (Conflicto de Datos / Duplicados)
Se devuelve cuando se intenta registrar un valor único que ya existe en el sistema (ej. intentar registrar una dirección MAC o un email ya existentes).

```json
{
  "type": "https://api.ojosdesol.com/errors/conflict",
  "title": "Conflicto de Datos",
  "status": 409,
  "detail": "El recurso que intenta crear entra en conflicto con un registro existente (ej. email o dirección MAC ya registrados).",
  "instance": "/devices"
}
```

### 422 Unprocessable Entity (Reglas de Negocio Violadas)
Se devuelve cuando la petición es sintácticamente correcta pero viola restricciones semánticas o lógicas de negocio (ej. programar un horario de fin anterior al horario de inicio).

```json
{
  "type": "https://api.ojosdesol.com/errors/unprocessable-entity",
  "title": "Entidad no Procesable",
  "status": 422,
  "detail": "La fecha/hora de finalización no puede ser anterior o igual a la fecha/hora de inicio.",
  "instance": "/devices/1/schedules"
}
```

### 500 Internal Server Error (Fallo Interno del Servidor)
Cualquier error inesperado a nivel de base de datos, código del servidor o conexión de red interna que no pueda ser resuelto por el cliente.

```json
{
  "type": "https://api.ojosdesol.com/errors/internal-server-error",
  "title": "Fallo Interno del Servidor",
  "status": 500,
  "detail": "Ha ocurrido un error inesperado en el servidor. Por favor, contacte al administrador con el código de rastreo.",
  "instance": "/health"
}
```

---

## 3. Catálogo de Mensajes de Validación por Modelo (invalid_params)

A continuación se detallan todas las validaciones de campos que el servidor evalúa y el mensaje de error exacto (`reason`) asignado a cada campo inválido.

### 3.1. Registro y Creación de Usuarios (`RegisterRequest` / `CreateUserRequest`)
*Aplica a endpoints:* `POST /auth/register` y `POST /users`

| Campo | Tipo | Restricción OpenAPI / DB | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`username`** | String | Requerido, 3-20 caracteres, patrón: `^[a-zA-Z0-9_.]{3,20}$` | "El nombre de usuario debe tener entre 3 y 20 caracteres y contener únicamente letras, números, puntos (.) o guiones bajos (_)." |
| **`name`** | String | Requerido, máx 50 caracteres | "El nombre es obligatorio y no puede superar los 50 caracteres." |
| **`last_name`** | String | Requerido, máx 70 caracteres | "El apellido es obligatorio y no puede superar los 70 caracteres." |
| **`birth_date`** | String | Requerido, formato: `date` (`YYYY-MM-DD`) | "La fecha de nacimiento es obligatoria y debe cumplir con el formato ISO 8601 (YYYY-MM-DD)." |
| **`phone`** | String | Opcional (puede ser `null`), máx 20 caracteres, patrón: `^\+?[0-9\s\-().]{7,20}$` | "El número de teléfono debe tener un formato internacional válido y una longitud de entre 7 y 20 dígitos." |
| **`email`** | String | Requerido, formato: `email`, máx 80 caracteres | "El correo electrónico debe ser una dirección de email válida y no puede exceder los 80 caracteres." |
| **`password`** | String | Requerido, min 8 caracteres | "La contraseña debe tener una longitud mínima de 8 caracteres." |
| **`role_id`** | Integer | Requerido, debe ser entero positivo | "El identificador de rol seleccionado es obligatorio y debe ser un número entero válido." |

#### Ejemplo de Respuesta de Error de Validación en Registro:
```json
{
  "type": "https://api.ojosdesol.com/errors/validation-error",
  "title": "Error de Validación",
  "status": 400,
  "detail": "Los campos provistos en la solicitud de registro contienen errores.",
  "instance": "/auth/register",
  "invalid_params": [
    {
      "name": "username",
      "reason": "El nombre de usuario debe tener entre 3 y 20 caracteres y contener únicamente letras, números, puntos (.) o guiones bajos (_)."
    },
    {
      "name": "password",
      "reason": "La contraseña debe tener una longitud mínima de 8 caracteres."
    }
  ]
}
```

---

### 3.2. Actualización de Usuarios (`UpdateUserRequest`)
*Aplica a endpoints:* `PUT /users/{userId}` y `PATCH /users/{userId}`
*Nota: Todos los campos son opcionales pero, si se envían, deben cumplir con sus restricciones.*

| Campo | Tipo | Restricción OpenAPI / DB | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`username`** | String | Opcional, 3-20 caracteres, patrón: `^[a-zA-Z0-9_.]{3,20}$` | "El nombre de usuario debe tener entre 3 y 20 caracteres y contener únicamente letras, números, puntos (.) o guiones bajos (_)." |
| **`name`** | String | Opcional, máx 50 caracteres | "El nombre no puede superar los 50 caracteres." |
| **`last_name`** | String | Opcional, máx 70 caracteres | "El apellido no puede superar los 70 caracteres." |
| **`birth_date`** | String | Opcional, formato: `date` (`YYYY-MM-DD`) | "La fecha de nacimiento debe cumplir con el formato ISO 8601 (YYYY-MM-DD)." |
| **`phone`** | String | Opcional (puede ser `null`), máx 20 caracteres, patrón: `^\+?[0-9\s\-().]{7,20}$` | "El número de teléfono debe tener un formato internacional válido y una longitud de entre 7 y 20 dígitos." |
| **`role_id`** | Integer | Opcional, entero positivo | "El identificador de rol seleccionado debe ser un número entero válido." |

---

### 3.3. Inicio de Sesión (`LoginRequest`)
*Aplica a endpoints:* `POST /auth/login`

| Campo | Tipo | Restricción OpenAPI | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`email`** | String | Requerido, formato: `email` | "Se requiere una dirección de correo electrónico válida." |
| **`password`** | String | Requerido | "Se requiere la contraseña de acceso." |

---

### 3.4. Creación de Roles (`CreateRoleRequest`)
*Aplica a endpoints:* `POST /roles`

| Campo | Tipo | Restricción OpenAPI / DB | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`name_role`** | String | Requerido, máx 30 caracteres, patrón: `^[a-zA-ZáéíóúÁÉÍÓÚ\s]{2,30}$` | "El nombre del rol es requerido, debe tener entre 2 y 30 caracteres, y contener únicamente letras y espacios." |
| **`permission_ids`** | Array[Int] | Requerido, arreglo de enteros | "Debe proveer una lista válida con al menos un ID de permiso (número entero positivo)." |

---

### 3.5. Vinculación de Dispositivos (`LinkDeviceRequest`)
*Aplica a endpoints:* `POST /devices`

| Campo | Tipo | Restricción OpenAPI / DB | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`mac_address`** | String | Requerido, máx 17 caracteres, patrón MAC de 6 octetos | "La dirección MAC es obligatoria y debe cumplir con el formato estándar de red de 6 pares de dígitos hexadecimales separados por dos puntos o guiones (ej. AA:BB:CC:DD:EE:FF)." |
| **`alias`** | String | Requerido, máx 80 caracteres, patrón: `^[\w\s.'-]{2,80}$` | "El alias del dispositivo es obligatorio, debe tener entre 2 y 80 caracteres y solo permite letras, números, espacios, puntos, comillas simples y guiones." |

---

### 3.6. Ingesta de Telemetría desde ESP32 (`TelemetryInput`)
*Aplica a endpoints:* `POST /devices/{deviceId}/telemetry`

| Campo | Tipo | Restricción OpenAPI / DB | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`energy_in_wh`** | Number | Requerido, mínimo: 0 | "La energía acumulada de entrada (generada) no puede ser un valor negativo." |
| **`energy_out_wh`** | Number | Requerido, mínimo: 0 | "La energía acumulada de salida (consumida) no puede ser un valor negativo." |
| **`voltage_v`** | Number | Requerido, rango: 0 a 30 | "El voltaje medido por el dispositivo debe estar en el rango seguro de 0 a 30 Volts." |
| **`current_a`** | Number | Requerido, mínimo: 0 | "La corriente medida instantánea no puede ser un valor negativo." |
| **`watts_now`** | Number | Requerido, mínimo: 0 | "La potencia instantánea calculada en Watts no puede ser un valor negativo." |
| **`current_angle_deg`** | Number | Requerido, rango: 0 a 360 | "El ángulo actual reportado del servomotor debe encontrarse en un rango de 0 a 360 grados." |
| **`sensor_params`** | Object | Requerido, JSON estructurado | "Se requiere el objeto JSON con los parámetros adicionales de los sensores." |

---

### 3.7. Comandos de Movimiento Manual (`SendCommandRequest`)
*Aplica a endpoints:* `POST /devices/{deviceId}/commands`

| Campo | Tipo | Restricción OpenAPI / DB | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`topic`** | String | Requerido, máx 250 caracteres | "El tópico MQTT especificado para enviar el comando no puede superar los 250 caracteres de longitud." |
| **`message.angle_deg`** | Number | Requerido (dentro de message), rango: 0 a 360 | "El ángulo de comando enviado al servomotor del panel solar debe estar obligatoriamente entre 0 y 360 grados." |

---

### 3.8. Configuración de Umbrales de Alertas (`AlertSettings`)
*Aplica a endpoints:* `PUT /devices/{deviceId}/alert-settings`
*Nota: Al actualizarse la configuración, el servidor realiza estas validaciones.*

| Campo | Tipo | Restricción OpenAPI / DB | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`battery_overcharge_threshold`** | Number | Rango: 50 a 100 | "El umbral de sobrecarga de la batería debe establecerse en un valor porcentual de entre el 50% y el 100%." |
| **`min_generation_threshold_percent`** | Number | Rango: 10 a 100 | "El umbral mínimo de generación energética debe estar configurado entre el 10% y el 100% de la media histórica." |
| **`connectivity_timeout_minutes`** | Integer | Rango: 1 a 60 | "El tiempo de tolerancia para desconexión del dispositivo debe ser un entero de entre 1 y 60 minutos." |

---

### 3.9. Programación de Horarios de Operación (`CreateScheduleRequest`)
*Aplica a endpoints:* `POST /devices/{deviceId}/schedules` y `PUT /devices/{deviceId}/schedules/{scheduleId}`

| Campo | Tipo | Restricción OpenAPI / DB | Mensaje de Error Exacto (`reason`) |
| :--- | :--- | :--- | :--- |
| **`label`** | String | Requerido, máx 100 caracteres | "La etiqueta o nombre descriptivo del horario es obligatoria y no puede exceder los 100 caracteres." |
| **`start_time`** | String | Requerido, formato: `date-time` | "La hora de inicio de la programación debe tener un formato válido de fecha y hora ISO 8601." |
| **`end_time`** | String | Requerido, formato: `date-time` | "La hora de finalización debe tener un formato de fecha y hora ISO 8601 y ser lógicamente posterior a la fecha y hora de inicio." |
| **`active`** | Boolean | Opcional, default: `true` | "El estado del horario debe ser un valor booleano (true o false)." |

---

## 4. Validaciones de Path Parameters (Parámetros en URL)

Los parámetros embebidos en las URLs (como `{userId}`, `{deviceId}`, `{scheduleId}`, `{alertId}`) también están validados en el enrutador antes de llegar a los controladores:

* **Tipo de dato entero (UserId, DeviceId, RoleId, ScheduleId):**
  * **Fallo:** Enviar `/users/carlos` o `/devices/abc`.
  * **Respuesta (400 Bad Request):**
    ```json
    {
      "type": "https://api.ojosdesol.com/errors/bad-request",
      "title": "Parámetro de Ruta Inválido",
      "status": 400,
      "detail": "El parámetro identificador en la URL debe ser un número entero válido (SMALLINT).",
      "instance": "/users/carlos"
    }
    ```

* **Tipo de dato ObjectId de MongoDB (AlertId, CommandId, ScheduleId de NoSQL):**
  * **Fallo:** Enviar `/alerts/12345` (cuando se espera un ID de 24 caracteres hexadecimales de MongoDB).
  * **Respuesta (400 Bad Request):**
    ```json
    {
      "type": "https://api.ojosdesol.com/errors/bad-request",
      "title": "Identificador NoSQL Inválido",
      "status": 400,
      "detail": "El identificador de alerta o comando en la URL debe ser un ID de MongoDB válido (ObjectId de 24 caracteres hexadecimales).",
      "instance": "/alerts/12345/acknowledge"
    }
    ```
