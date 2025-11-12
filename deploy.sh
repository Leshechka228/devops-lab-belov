#!/bin/bash

echo "🚀 Начинаем развертывание демо-сайта - belov"

# Определяем корневую директорию проекта
PROJECT_ROOT="/home/alexey/devops-lab"

echo "📁 Корневая директория проекта: $PROJECT_ROOT"

# Проверяем существование основных файлов
echo "🔍 Проверяем необходимые файлы..."
if [ ! -f "$PROJECT_ROOT/index.html" ]; then
    echo "❌ index.html не найден в $PROJECT_ROOT"
    exit 1
fi

if [ ! -f "$PROJECT_ROOT/nginx.conf" ]; then
    echo "❌ nginx.conf не найден в $PROJECT_ROOT"
    exit 1
fi

# Проверяем, установлен ли nginx
if ! command -v nginx &> /dev/null; then
    echo "❌ nginx не установлен."
    exit 1
fi

# Создаем директорию для сайта
echo "📁 Создаем директорию для сайта..."
sudo mkdir -p /var/www/demo

# Копируем файлы
echo "📄 Копируем файлы сайта..."
sudo cp "$PROJECT_ROOT/index.html" /var/www/demo/
sudo cp "$PROJECT_ROOT/nginx.conf" /etc/nginx/sites-available/demo-site

# Создаем симлинк если не существует
if [ ! -L /etc/nginx/sites-enabled/demo-site ]; then
    sudo ln -sf /etc/nginx/sites-available/demo-site /etc/nginx/sites-enabled/
fi

# Удаляем дефолтную конфигурацию nginx если она есть
sudo rm -f /etc/nginx/sites-enabled/default

# Проверяем конфигурацию
echo "🔍 Проверяем конфигурацию nginx..."
if ! sudo nginx -t; then
    echo "❌ Ошибка в конфигурации nginx"
    exit 1
fi

# Перезапускаем nginx
echo "🔄 Перезапускаем nginx..."
sudo systemctl reload nginx

# Проверяем что nginx слушает на порту 8181
if sudo netstat -tulpn | grep -q ":8181 "; then
    echo "✅ nginx слушает на порту 8181"
else
    echo "⚠️  nginx может не слушать на порту 8181"
fi

echo "✅ Развертывание завершено успешно!"
echo "🌐 Сайт доступен по адресу: http://app.belov.course.prafdin.ru"
echo "🔗 Локально: http://localhost:8181"
