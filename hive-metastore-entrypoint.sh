#!/bin/sh

# Явно отключаем автоматическую детекцию Derby
export SKIP_SCHEMA_INIT=true

# Параметры подключения к PostgreSQL
POSTGRES_URL="jdbc:postgresql://postgres:5432/metastore_db"
POSTGRES_DRIVER="org.postgresql.Driver"
POSTGRES_USER="muser"
POSTGRES_PASSWORD="mpassword"

# 🔧 КРИТИЧЕСКИ ВАЖНО: Добавляем JAR-файлы для работы с S3A в classpath Hadoop
# Указываем пути к JAR-файлам, которые смонтированы в контейнер (ОБНОВЛЕННЫЕ ВЕРСИИ)
export HADOOP_CLASSPATH="/opt/hive/lib/hadoop-aws-3.3.6.jar:/opt/hive/lib/aws-java-sdk-bundle-1.12.367.jar"

# Инициализация схемы, если SKIP_SCHEMA_INIT не равен "true"
if [ "$SKIP_SCHEMA_INIT" != "true" ]; then
  schematool -initSchema -dbType postgres
fi

# Запуск Hive Metastore с указанными конфигурациями
exec /opt/hive/bin/hive --service metastore \
  -hiveconf javax.jdo.option.ConnectionURL="$POSTGRES_URL" \
  -hiveconf javax.jdo.option.ConnectionDriverName="$POSTGRES_DRIVER" \
  -hiveconf javax.jdo.option.ConnectionUserName="$POSTGRES_USER" \
  -hiveconf javax.jdo.option.ConnectionPassword="$POSTGRES_PASSWORD" \
  -hiveconf hive.metastore.schema.verification=false \
  -hiveconf hive.metastore.warehouse.dir="hdfs://namenode:9000/user/hive/warehouse" \
  -hiveconf datanucleus.schema.autoCreateAll=true
  