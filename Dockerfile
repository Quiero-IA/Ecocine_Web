# Paso 1: Compilar la aplicación de Lovable usando Node.js
FROM node:20-alpine AS build
WORKDIR /app

# Copiamos tu archivo de configuración en español
COPY paquete*.json ./

# Instalamos las herramientas para procesar el proyecto
RUN npm install
COPY . .
RUN npm run build

# Paso 2: Servir los archivos listos usando un servidor Nginx ligero
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
