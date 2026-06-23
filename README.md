# Documentación de API - Ojos de Sol

Este proyecto contiene la especificación y el portal interactivo de la API de **Ojos de Sol** utilizando **OpenAPI 3.0** y **Stoplight Elements**.

El servidor está completamente dockerizado y configurado con **recarga en vivo (hot-reload)**, lo que significa que cualquier cambio que realices en `openapi.yaml` o `index.html` se reflejará inmediatamente en el navegador sin necesidad de reconstruir o reiniciar el contenedor.

## Requisitos

* [Docker](https://www.docker.com/) instalado en tu equipo.
* [Docker Compose](https://docs.docker.com/compose/) (incluido por defecto en Docker Desktop).

## Estructura del Proyecto

* 📄 `openapi.yaml` - Especificación oficial de la API. Aquí es donde agregas rutas, parámetros, esquemas de datos y respuestas.
* 📄 `index.html` - Portal web interactivo que renderiza la documentación con un diseño moderno.
* 🐳 `Dockerfile` - Configuración de la imagen basada en Nginx.
* 🐙 `docker-compose.yml` - Configuración del servicio de Docker con montaje de volúmenes para desarrollo.

## Cómo levantar el servidor

Para construir e iniciar el contenedor, ejecuta el siguiente comando en tu terminal:

```bash
docker compose up --build -d
```

Una vez iniciado, abre tu navegador e ingresa a:

👉 **[http://localhost:8080](http://localhost:8080)**

## Desarrollo y Edición

Dado que el archivo `openapi.yaml` se encuentra montado como un volumen dentro del contenedor, puedes editar directamente el archivo usando tu editor de código preferido. Al guardar los cambios y recargar la página en el navegador, verás la documentación actualizada instantáneamente.

## Comandos Útiles

* **Detener la documentación:**
  ```bash
  docker compose down
  ```

* **Ver los logs en tiempo real:**
  ```bash
  docker compose logs -f
  ```
