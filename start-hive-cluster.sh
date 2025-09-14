#!/bin/bash

# Скачивание PostgreSQL JDBC драйвера
if [ ! -f "postgresql-42.5.1.jar" ]; then
    echo "Downloading PostgreSQL JDBC driver..."
    wget https://jdbc.postgresql.org/download/postgresql-42.5.1.jar
fi

# Инициализация сети и volumes
echo "Creating network and volumes..."
docker network create hive-network 2>/dev/null || true

# Запуск сервисов
echo "Starting services..."
docker-compose up -d

# Ожидание инициализации PostgreSQL
echo "Waiting for PostgreSQL to be ready..."
sleep 10

# Инициализация Hive Metastore schema
echo "Initializing Hive Metastore schema..."
docker exec -it hive-metastore schematool -initSchema -dbType postgres

echo "Hive cluster is starting up..."
echo "Access points:"
echo " - HDFS Namenode UI: http://localhost:9870"
echo " - HiveServer2 UI: http://localhost:10002"
echo " - PostgreSQL: localhost:5432"
