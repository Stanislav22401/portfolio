# ---- Этап 1: Сборка статического сайта ----
FROM node:24-alpine AS builder

WORKDIR /app

# Копируем файлы зависимостей
COPY package.json package-lock.json* ./

RUN npm ci --only=production=false

# Копируем исходный код
COPY . .

# Сборка проекта (Astro по умолчанию создаёт папку dist)
RUN npm run build

# ---- Этап 2: Сервер Nginx для статики ----
FROM nginx:alpine

# Копируем собранные статические файлы из предыдущего этапа
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
