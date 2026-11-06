# Build context: ./frontend
FROM node:20-alpine AS build
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Static files served by unprivileged nginx on :8081
FROM nginxinc/nginx-unprivileged:1.27-alpine
RUN sed -i 's/listen       8080;/listen       8081;/' /etc/nginx/conf.d/default.conf
COPY --from=build /src/dist /usr/share/nginx/html
EXPOSE 8081
