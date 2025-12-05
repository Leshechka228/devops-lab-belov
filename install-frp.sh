#!/bin/bash

# Скрипт установки FRP клиента
# Использование: sudo ./install-frp.sh [SERVER_ADDR] [AUTH_TOKEN] [USERNAME]

set -e

# Параметры
SERVER_ADDR=${1:-"course.prafdin.ru"}
AUTH_TOKEN=${2:-"devops"}
USERNAME=${3:-"belov"}

echo "🚀 Установка FRP клиента..."
echo "📋 Параметры:"
echo "   Сервер: $SERVER_ADDR"
echo "   Токен: ${AUTH_TOKEN:0:8}***"
echo "   Пользователь: $USERNAME"

# Проверяем права суперпользователя
if [[ $EUID -ne 0 ]]; then
   echo "❌ Этот скрипт должен запускаться с правами root (sudo)"
   exit 1
fi

# Создаем директорию для FRP
mkdir -p /etc/frp
mkdir -p /var/log/frp

if command -v frpc >/dev/null 2>&1; then
   echo "✅ FRP клиент уже установлен"
   echo "⏭ Пропускаем установку..."
else
   echo "📥 Скачиваем и устанавливаем FRP..."
   wget -qO- https://gist.github.com/lawrenceching/41244a182307940cc15b45e3c4997346/raw/0576ea85d898c965c3137f7c38f9815e1233e0d1/install-frp-as-systemd-service.sh | bash
fi

# Генерируем конфигурацию
echo "⚙️  Генерируем конфигурацию..."
cat > /etc/frp/frpc.toml << CONFEOF
serverAddr = "$SERVER_ADDR"
serverPort = 7000

auth.method = "token"
auth.token = "$AUTH_TOKEN"

# Прокси для webhook сервера
[[proxies]]
name = "hook-$USERNAME"
type = "http"
localIP = "127.0.0.1"
localPort = 8080
customDomains = ["webhook.$USERNAME.$SERVER_ADDR"]

# Прокси для веб-приложения
[[proxies]]
name = "app-$USERNAME"
type = "http"
localIP = "127.0.0.1"
localPort = 8383
customDomains = ["app.$USERNAME.$SERVER_ADDR"]
CONFEOF

echo "✅ Конфигурация создана"

# Запускаем FRP клиент
systemctl daemon-reload
systemctl enable frpc
systemctl restart frpc

echo "📊 Проверяем статус FRP..."
systemctl status frpc --no-pager

echo ""
echo "✅ FRP клиент настроен!"
echo "🌐 Webhook URL: http://webhook.$USERNAME.$SERVER_ADDR"
echo "🌐 App URL: http://app.$USERNAME.$SERVER_ADDR"
