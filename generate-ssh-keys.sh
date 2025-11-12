#!/bin/bash

echo "🔑 Генерация SSH ключей для GitHub Actions..."

# Генерируем SSH ключи
ssh-keygen -t rsa -b 4096 -C "github-actions-$(hostname)" -f ~/.ssh/github_actions -N ""

# Добавляем публичный ключ в authorized_keys
cat ~/.ssh/github_actions.pub >> ~/.ssh/authorized_keys

# Устанавливаем правильные права
chmod 600 ~/.ssh/github_actions
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh

echo "✅ Публичный ключ добавлен в authorized_keys"
echo ""
echo "=== ПРИВАТНЫЙ КЛЮЧ (скопируйте ВСЁ для GitHub Secrets) ==="
cat ~/.ssh/github_actions
echo "=== КОНЕЦ ПРИВАТНОГО КЛЮЧА ==="
