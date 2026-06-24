# **Diccionario de errores**

Subtítulo o descripción general del documento oficial

INTRODUCCIÓN

En este documento se estará trabajando en el diccionario de errores.

## **Sección Principal**

### **RFC 9457 — Estructura estándar de errores**

La norma RFC 9457 define los campos estándar: `type`, `title`, `status`, `detail` e `instance`. El `Content-Type` de la respuesta debe ser `application/problem+json`.

| Campos base del RFC 9457 |  |  |
| ----- | ----- | ----- |
| **Campo** | **Tipo** | **Descripción** |
| **type** | **string (URI)** | **Identifica el tipo de problema** |
| **title** | **string** | **Descripción corta del problema** |
| **status** | **integer** | **Código HTTP del error** |
| **detail** | **string** | **Explicación específica de esta ocurrencia** |
| **instance** | **string (URI)** | **Ruta/ID de la solicitud que falló (endpoint)** |
| **code** | **string** | **Código para identificar el error** |
| **technical\_detail** | **string** | **Descripción detallada del error de manera técnica** |
| **user\_message** | **string** | **Descripción genérica para mostrar al usuario final.**  |

 

Catálogo de errores:

1. INTERNAL\_DATABASE\_ERROR:

| {  "type": "https://api.tuapp.com/problems/internal-database-error",  "title": "Error interno de base de datos",  "status": 500,  "detail": "An unexpected database error occurred while processing the request.",  "instance": "/api/v1/orders/create",  "code": "INTERNAL\_DATABASE\_ERROR",  "technical\_detail": "SQLSTATE\[HY000\]: Connection refused. Host: mysql-primary:3306",  "user\_message": "Estamos teniendo problemas técnicos. Por favor intenta en unos minutos."} |
| :---- |

2. INTERNAL\_THIRD\_PARTY\_TIMEOUT:

| {  "type": "https://api.tuapp.com/problems/internal-third-party-timeout",  "title": "Tiempo de espera agotado en servicio externo",  "status": 500,  "detail": "The request to an external service timed out.",  "instance": "/api/v1/payments/process",  "code": "INTERNAL\_THIRD\_PARTY\_TIMEOUT",  "technical\_detail": "Timeout calling https://payments-provider.com/v2/charge after 15000ms",  "user\_message": "El servicio está tardando más de lo esperado. Por favor intenta de nuevo."} |
| :---- |

   

3. INTERNAL\_UNHANDLED\_EXCEPTION:

| {  "type": "https://api.tuapp.com/problems/internal-unhandled-exception",  "title": "Excepción no controlada",  "status": 500,  "detail": "An unhandled exception occurred while processing the request.",  "instance": "/api/v1/orders/987/shipments",  "code": "INTERNAL\_UNHANDLED\_EXCEPTION",  "technical\_detail": "TypeError: Cannot read property 'id' of undefined at ShipmentController.php:58",  "user\_message": "Algo salió mal de nuestro lado. Ya estamos trabajando en solucionarlo."} |
| :---- |

4. INTERNAL\_SERVICE\_UNAVAILABLE:

| {  "type": "https://api.tuapp.com/problems/internal-service-unavailable",  "title": "Servicio no disponible",  "status": 503,  "detail": "The service is temporarily unable to handle the request.",  "instance": "/api/v1/orders/create",  "code": "INTERNAL\_SERVICE\_UNAVAILABLE",  "technical\_detail": "Database connection pool exhausted. Active connections: 100/100",  "user\_message": "El servicio no está disponible en este momento. Por favor intenta más tarde."} |
| :---- |

Headers:

| HTTP/1.1 503 Service UnavailableContent-Type: application/problem+jsonRetry-After: 30 |
| :---- |

Retry-After: sirve para hacerle saber al cliente que puede reintentar después de esa cantidad de segundos

5. INTERNAL\_SERVICE\_UNAVAILABLE\_BY\_MAINTENANCE

| {  "type": "https://api.tuapp.com/problems/internal-service-unavailable",  "title": "Servicio en mantenimiento",  "status": 503,  "detail": "The service is currently undergoing scheduled maintenance.",  "instance": "/api/v1/orders/create",  "code": "INTERNAL\_SERVICE\_UNAVAILABLE\_BY\_MAINTENANCE",  "technical\_detail": "Scheduled maintenance window: 2026-06-19T02:00:00Z \- 2026-06-19T04:00:00Z",  "user\_message": "Estamos realizando mantenimiento. El servicio estará disponible a partir del 19 de Junio a las 12:00.",} |
| :---- |

6. CLIENT\_BAD\_REQUEST

| {  "type": "https://api.tuapp.com/problems/client-bad-request",  "title": "Solicitud incorrecta",  "status": 400,  "detail": "The request body contains invalid or malformed JSON syntax.",  "instance": "/api/v1/orders/create",  "code": "CLIENT\_BAD\_REQUEST",  "technical\_detail": "Unexpected token '}' at position 142 in request body.",  "user\_message": "La solicitud no pudo procesarse. Verifica los datos enviados e intenta de nuevo."} |
| :---- |

   

7. CLIENT\_UNAUTHORIZED

| {  "type": "https://api.tuapp.com/problems/client-unauthorized",  "title": "No autorizado",  "status": 401,  "detail": "The request requires a valid authentication token.",  "instance": "/api/v1/orders",  "code": "CLIENT\_UNAUTHORIZED",  "technical\_detail": "Authorization header is missing or the JWT token has expired. Token exp: 2026-06-17T10:00:00Z",  "user\_message": "Tu sesión ha expirado. Por favor inicia sesión nuevamente."} |
| :---- |

8. CLIENT\_FORBIDDEN

| {  "type": "https://api.tuapp.com/problems/client-forbidden",  "title": "Acceso denegado",  "status": 403,  "detail": "The authenticated user does not have permission to access this resource.",  "instance": "/api/v1/admin/users",  "code": "CLIENT\_FORBIDDEN",  "technical\_detail": "User ID 482 with role 'customer' attempted to access admin-only endpoint.",  "user\_message": "No tienes permisos para realizar esta acción."} |
| :---- |

9. CLIENT\_NOT\_FOUND

| {  "type": "https://api.tuapp.com/problems/client-not-found",  "title": "Recurso no encontrado",  "status": 404,  "detail": "The requested resource does not exist or the ID provided is invalid.",  "instance": "/api/v1/orders/987",  "code": "CLIENT\_NOT\_FOUND",  "technical\_detail": "Order with ID 987 not found in database. Table: orders.",  "user\_message": "El recurso solicitado no existe. Verifica la información e intenta de nuevo."} |
| :---- |

10. CLIENT\_VALIDATION\_ERROR

| {  "type": "https://api.tuapp.com/problems/client-validation-error",  "title": "Error de validación",  "status": 422,  "detail": "The request contains fields with invalid or missing values.",  "instance": "/api/v1/orders/create",  "code": "CLIENT\_VALIDATION\_ERROR",  "technical\_detail": "Validation failed for fields: 'email', 'age'.",  "user\_message": "Algunos campos contienen errores. Por favor revísalos e intenta de nuevo.",  "errors": \[    {      "detail": "El campo 'email' es requerido.",      "pointer": "/email"    },    {      "detail": "El campo 'age' debe estar entre 0 y 120.",      "pointer": "/age"    }  \]} |
| :---- |

**Resumen del catálogo:**

| Code | Status |
| ----- | ----- |
| **CLIENT\_BAD\_REQUEST** | **400** |
| **CLIENT\_UNAUTHORIZED** | **401** |
| **CLIENT\_FORBIDDEN** | **403** |
| **CLIENT\_NOT\_FOUND** | **404** |
| **CLIENT\_VALIDATION\_ERROR** | **422** |
| **INTERNAL\_DATABASE\_ERROR** | **500** |
| **INTERNAL\_THIRD\_PARTY\_TIMEOUT** | **500** |
| **INTERNAL\_UNHANDLED\_EXCEPTION** | **500** |
| **INTERNAL\_SERVICE\_UNAVAILABLE** | **503** |
| **INTERNAL\_SERVICE\_UNAVAILABLE\_BY\_MAINTENANCE** | **503** |

