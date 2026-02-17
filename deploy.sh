#!/bin/bash

# Путь к проекту
PROJECT_DIR="/home/user/crm-test.pp.ru"

cd $PROJECT_DIR || exit 1

# Сбрасываем локальные изменения и подтягиваем новые из git
git reset --hard
git pull origin main

# Останавливаем старый dev-сервер (если есть)
pm2 stop quasar-dev 2>/dev/null

# Запускаем Quasar dev на порту 8080 через pm2
pm2 start "quasar dev -m spa -p 8080" --name quasar-dev --cwd $PROJECT_DIR
