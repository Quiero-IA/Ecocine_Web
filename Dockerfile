# Paso 1: Compilar la aplicación con Node.js usando trucos de ahorro de RAM
FROM node:20-alpine AS build
WORKDIR /app

# Copiamos solo las listas de paquetes para aprovechar la memoria caché
COPY package*.json ./

# Instalamos dependencias saltándonos auditorías pesadas para no saturar el servidor
RUN npm install --no-audit --no-fund

# Copiamos el resto de los archivos y compilamos la web
COPY . .
RUN npm run build

# Paso 2: Servir la página con Nginx ligero (consume casi 0% de RAM)
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
