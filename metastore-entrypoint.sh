#!/bin/sh
set -e

# Установка classpath из hadoop command
echo "Setting up Hadoop and Hive classpath..."
# export HADOOP_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath --glob):/opt/hive/lib/*
# export CLASSPATH=$HADOOP_CLASSPATH

# export HADOOP_CLASSPATH="/opt/hadoop/*:/opt/hive/lib/*"
export HADOOP_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath --glob)
export HADOOP_HOME=/opt/hadoop
# echo $HADOOP_HOME
# echo "Classpath - "
# echo $HADOOP_CLASSPATH
# echo "- Classpath "

# Создаем директорию если не существует
if [ ! -d "/home/hive" ]; then
    echo "Creating /home/hive directory..."
    mkdir -p /home/hive
    chown hive:hive /home/hive
    chmod 755 /home/hive
fi

# Запуск Hive Metastore сервиса
echo "Starting Hive Metastore service on port 9083..."
exec /opt/hive/bin/hive --service metastore -p 9083