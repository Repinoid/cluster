#!/bin/sh
set -e

# Создаем директорию если не существует
if [ ! -d "/home/hive" ]; then
    echo "Creating /home/hive directory..."
    mkdir -p /home/hive
    chown hive:hive /home/hive  # ← Меняем владельца
    chmod 755 /home/hive        # ← Назначаем права
fi

# Запускаем Hive Metastore сервис
echo "Starting Hive Metastore service on port 9083..."
exec /opt/hive/bin/hive --service metastore -p 9083