FROM node:alpine

WORKDIR /app

# Configurar variables de entorno para pnpm
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Instalar pnpm y luego live-server para recarga en vivo automática (hot-reload)
RUN npm install -g pnpm && pnpm config set global-bin-dir /pnpm && pnpm add -g live-server

# Exponer el puerto 80
EXPOSE 80

# Iniciar live-server sirviendo el directorio actual en el puerto 80
CMD ["live-server", "--port=80", "--host=0.0.0.0", "--no-browser"]
