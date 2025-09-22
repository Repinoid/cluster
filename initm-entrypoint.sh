#!/bin/sh
set -e

# Явно указываем использование PostgreSQL
echo "Forcing PostgreSQL connection..."
/opt/hive/bin/schematool -initSchema \
  -dbType postgres \
  -userName hiveuser \
  -passWord hivepassword \
  -url jdbc:postgresql://metastore-db:5432/metastore \
  -verbose

# Проверяем результат
if [ $? -eq 0 ]; then
  echo "PostgreSQL schema initialization successful!"
  exit 0
else
  echo "PostgreSQL schema initialization failed!"
  exit 1
fi
