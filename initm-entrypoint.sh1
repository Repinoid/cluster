#!/bin/sh
set -e  # Выход при любой ошибке

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Функция для логирования в stdout
log() {
    echo "$TIMESTAMP - $1"
}

log "INFO: Starting Hive Metastore initialization script."

# Проверка наличия утилиты schematool
if [ ! -f "/opt/hive/bin/schematool" ]; then
    log "ERROR: schematool not found at /opt/hive/bin/schematool. Exiting."
    exit 1
else
    log "INFO: schematool found."
fi

# ПРОВЕРКА НАЛИЧИЯ JDBC-ДРАЙВЕРА POSTGRESQL В ДИРЕКТОРИИ
log "INFO: Checking for PostgreSQL JDBC driver in /opt/hive/lib/..."
DRIVER_FOUND=$(ls /opt/hive/lib/ | grep -i postgres | head -n 1)

if [ -z "$DRIVER_FOUND" ]; then
    log "ERROR: PostgreSQL JDBC driver not found in /opt/hive/lib/"
    log "ERROR: Contents of /opt/hive/lib/:"
    ls -la /opt/hive/lib/ | while read line; do log "ERROR: $line"; done
    log "ERROR: Please mount PostgreSQL JDBC driver to /opt/hive/lib/"
    exit 1
else
    log "INFO: Found PostgreSQL driver file: $DRIVER_FOUND"
    log "INFO: Full path: /opt/hive/lib/$DRIVER_FOUND"
fi

# Дополнительная проверка: существует ли файл драйвера
if [ ! -f "/opt/hive/lib/$DRIVER_FOUND" ]; then
    log "ERROR: Driver file /opt/hive/lib/$DRIVER_FOUND does not exist!"
    exit 1
fi

# ✅ КРИТИЧЕСКАЯ ПРОВЕРКА: ДОСТУПЕН ЛИ КЛАСС В CLASSPATH
log "INFO: Checking if org.postgresql.Driver class is available in classpath..."
if java -cp "/opt/hive/lib/$DRIVER_FOUND:/opt/hive/lib/*" org.postgresql.Driver 2>&1 | grep -q "ClassNotFoundException"; then
    log "ERROR: ❌ org.postgresql.Driver class NOT found in classpath!"
    log "ERROR: The driver JAR is present but the class is not accessible."
    log "ERROR: Possible reasons:"
    log "ERROR: 1. Corrupted JAR file"
    log "ERROR: 2. Wrong JAR file (not a PostgreSQL JDBC driver)"
    log "ERROR: 3. Classpath configuration issue"
    log "ERROR: Testing JAR integrity..."
    
    # Проверка что JAR файл действительный
    if ! jar -tf "/opt/hive/lib/$DRIVER_FOUND" | grep -q "org/postgresql/Driver"; then
        log "ERROR: ❌ JAR file does not contain org/postgresql/Driver class!"
        log "ERROR: This is not a valid PostgreSQL JDBC driver."
        log "ERROR: JAR contents:"
        jar -tf "/opt/hive/lib/$DRIVER_FOUND" | head -20 | while read line; do log "ERROR:   $line"; done
    else
        log "INFO: ✅ JAR file contains org/postgresql/Driver class"
        log "ERROR: But still not accessible in classpath - check classpath configuration"
    fi
    exit 1
else
    log "INFO: ✅ org.postgresql.Driver class is available in classpath"
fi

# Вывод информации для отладки
log "INFO: Using PostgreSQL URL: jdbc:postgresql://metastore-db:5432/metastore"
log "INFO: Using PostgreSQL user: hiveuser"

# Явно указываем использование PostgreSQL
log "INFO: Forcing PostgreSQL connection..."
log "INFO: Executing schematool command with verbose output."

# Запуск schematool с подробным выводом
/opt/hive/bin/schematool -initSchema \
  -dbType postgres \
  -userName hiveuser \
  -passWord hivepassword \
  -url jdbc:postgresql://metastore-db:5432/metastore \
  -verbose

# Проверяем результат выполнения schematool
SCHEMA_TOOL_EXIT_CODE=$?
if [ $SCHEMA_TOOL_EXIT_CODE -eq 0 ]; then
    log "INFO: PostgreSQL schema initialization successful!"
    exit 0
else
    log "ERROR: PostgreSQL schema initialization failed with exit code $SCHEMA_TOOL_EXIT_CODE."
    log "ERROR: Check the detailed logs above for troubleshooting."
    exit 1
fi
