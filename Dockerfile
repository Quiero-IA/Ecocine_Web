# Paso 1: Compilar usando Bun (El motor nativo de Lovable)
FROM oven/bun:alpine AS build
WORKDIR /app

# Copiamos los archivos de configuración y el candado de Bun
COPY package*.json ./
COPY bun.lock* ./

# Instalamos y compilamos a la velocidad de la luz
RUN bun install
COPY . .
RUN bun run build

# Paso 2: Servidor ligero Nginx para producción
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

