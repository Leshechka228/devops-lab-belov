#!/bin/bash

echo "🔍 ПРОВЕРКА СИСТЕМЫ - belov"
echo "============================"

# Проверяем сервисы
echo "📊 СЕРВИСЫ:"
sudo systemctl status nginx --no-pager | grep "Active:" | head -1
sudo systemctl status frpc --no-pager | grep "Active:" | head -1

echo ""
echo "🌐 ПОРТЫ:"
sudo netstat -tulpn | grep -E ':(80|8181|8080)' | while read line; do
    echo "   $line"
done

echo ""
echo "🔗 ВНЕШНИЕ URL:"
echo "   Webhook:  http://webhook.belov.course.prafdin.ru"
echo "   App:      http://app.belov.course.prafdin.ru"

echo ""
echo "🧪 ТЕСТЫ:"
curl -s http://localhost:8181 >/dev/null && echo "   ✅ App (localhost:8181) - работает" || echo "   ❌ App (localhost:8181) - не работает"
curl -s http://localhost:8080 >/dev/null && echo "   ✅ Webhook (localhost:8080) - работает" || echo "   ❌ Webhook (localhost:8080) - не работает"
curl -s http://app.belov.course.prafdin.ru >/dev/null && echo "   ✅ App (external) - работает" || echo "   ❌ App (external) - не работает"
curl -s http://webhook.belov.course.prafdin.ru >/dev/null && echo "   ✅ Webhook (external) - работает" || echo "   ❌ Webhook (external) - не работает"

echo ""
echo "📁 ФАЙЛЫ ПРОЕКТА:"
ls -la *.sh *.py *.html *.conf *.md 2>/dev/null

echo ""
echo "✅ ПРОВЕРКА ЗАВЕРШЕНА"
