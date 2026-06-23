Requerimientos funcionales
El sistema debe permitir el registro de nuevos usuarios con nombre, correo electrónico, contraseña y rol.
El sistema debe autenticar a los usuarios mediante correo electrónico y contraseña usando tokens JWT.
El sistema debe permitir el cierre de sesión del usuario desde la aplicación móvil y web.
El sistema debe permitir la recuperación de contraseña mediante enlace enviado al correo del usuario.
El sistema debe permitir a un administrador crear, editar y eliminar cuentas de usuario.
El sistema debe implementar roles diferenciados: Administrador y Cliente.
El sistema debe permitir la vinculación de un dispositivo ESP32 a una cuenta de usuario.
El sistema debe permitir la asignación de nombre descriptivo (alias) a cada dispositivo.
El sistema debe permitir la desvinculación de un dispositivo de la cuenta del usuario.
El sistema debe enviar las credenciales Wi-Fi al dispositivo mediante BLE durante la configuración inicial.
El sistema debe recibir datos de telemetría del dispositivo en tiempo real: voltaje (V), corriente (A), potencia (W) y energía acumulada (Wh).
El sistema debe almacenar el historial de telemetría de cada dispositivo en base de datos NoSQL (MongoDB).
El sistema debe generar resúmenes diarios de generación energética por dispositivo.
El sistema debe mostrar al usuario una gráfica de generación energética por hora del día actual.
El sistema debe mostrar gráficas históricas de generación energética semanal y mensual.
El sistema debe mostrar el estado de conectividad del dispositivo (activo / inactivo).
El sistema debe habilitar y deshabilitar el modo de seguimiento solar automático por dispositivo.
El sistema debe permitir al usuario enviar comandos manuales de ángulo (en grados) al servomotor del panel.
El sistema debe registrar el historial de comandos enviados con estado de entrega (encolado, entregado, rechazado).
El sistema debe generar una alerta cuando la energía generada sea significativamente menor al promedio histórico del dispositivo.
El sistema debe generar una alerta cuando el nivel de batería supere el 95% de capacidad y activar el corte de carga.
El sistema debe generar una alerta cuando el dispositivo pierda conectividad por más de 10 minutos.
El sistema debe enviar notificaciones push a la aplicación móvil cuando se genere una alerta.
El sistema debe permitir programar horarios de operación (hora inicio y hora fin) para cada dispositivo.
El sistema debe listar todos los horarios configurados para un dispositivo y permitir su edición.
El sistema debe permitir al administrador visualizar todos los dispositivos registrados en el sistema.
El sistema debe permitir al administrador crear, editar y eliminar roles y permisos del sistema.
El sistema debe mostrar en el panel web la lista completa de usuarios con su información y estado de cuenta.
El sistema debe permitir al administrador activar o desactivar cuentas de usuario.
El sistema debe mostrar al usuario el ángulo actual del panel solar en tiempo real.
El sistema debe mostrar indicadores visuales del estado de la batería (nivel de carga en porcentaje).
El sistema debe permitir al usuario filtrar el historial de datos por rango de fechas.
El sistema debe registrar la dirección MAC del dispositivo ESP32 como identificador único.
El sistema debe soportar múltiples dispositivos por cuenta de usuario.
El sistema debe implementar paginación en las listas de dispositivos, usuarios y comandos.
El sistema debe permitir al usuario exportar el resumen de generación energética en formato PDF.
El sistema debe mostrar la comparativa entre energía generada y energía consumida.
El sistema debe permitir al usuario configurar los umbrales de alerta (nivel de batería, rendimiento mínimo).
El sistema debe registrar un log de actividad de acceso y acciones por usuario (auditoría).

5. Requerimientos NO funcionales
Rendimiento: La API debe responder en menos de 500 ms para el 95% de las solicitudes bajo carga normal (hasta 100 usuarios concurrentes).
Disponibilidad: El sistema debe tener una disponibilidad del 99.5% mensual (SLA), equivalente a un máximo de 3.6 horas de inactividad planificada al mes.
Seguridad: Todas las comunicaciones entre cliente y servidor deben ir cifradas mediante HTTPS/TLS 1.2 o superior.
Seguridad de datos: Las contraseñas de usuario deben almacenarse exclusivamente como hashes bcrypt con factor de costo mínimo de 10.
Escalabilidad: La arquitectura debe permitir escalar horizontalmente los servicios de backend sin modificaciones en el código.
Latencia IoT: El tiempo de transmisión de datos de telemetría desde el ESP32 hasta la base de datos no debe superar los 3 segundos en condiciones normales de red.
Usabilidad: La aplicación móvil debe ser operable con una sola mano y cumplir con las guías de accesibilidad WCAG 2.1 nivel AA.
Compatibilidad móvil: La aplicación móvil debe ser compatible iOS 14 o superior.
Compatibilidad web: El panel web debe funcionar correctamente en los navegadores Chrome, Firefox, Safari y Edge en sus versiones actuales.
Mantenibilidad: El código fuente del proyecto debe mantener una cobertura mínima de pruebas unitarias del 50%.
Portabilidad: El backend debe poder desplegarse en contenedores Docker y ser compatible con AWS EC2 y servicios equivalentes.
Persistencia de datos: El sistema debe garantizar la integridad de los datos de telemetría, sin pérdidas, ante reinicios del dispositivo IoT.
Privacidad: El sistema debe cumplir con los principios de la Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP) de México.
Recuperabilidad: El sistema debe contar con respaldos automáticos diarios de la base de datos relacional, con retención mínima de 30 días.
Eficiencia energética del firmware: El firmware del ESP32 debe implementar modos de bajo consumo (deep sleep) durante períodos de inactividad para reducir el consumo del sistema de monitoreo.

