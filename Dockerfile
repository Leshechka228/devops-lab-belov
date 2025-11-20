# Используем легкий nginx образ
FROM nginx:alpine

# Копируем файлы нашего приложения
COPY index.html /usr/share/nginx/html/
COPY nginx-docker.conf /etc/nginx/conf.d/default.conf

# Открываем порт
EXPOSE 8181

# Команда запуска nginx
CMD ["nginx", "-g", "daemon off;"]
