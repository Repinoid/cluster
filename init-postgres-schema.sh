#!/bin/bash

# Явное указание параметров PostgreSQL
export METASTORE_DB_HOSTNAME=postgres
export METASTORE_DB_PORT=5432
export METASTORE_DB_NAME=metastore_db
export METASTORE_DB_USER=muser
export METASTORE_DB_PASSWORD=mpassword

# Принудительная инициализация PostgreSQL
/opt/hive/bin/schematool -initSchema -dbType postgres \
  -userName "$METASTORE_DB_USER" \
  -passWord "$METASTORE_DB_PASSWORD" \
  -url "jdbc:postgresql://$METASTORE_DB_HOSTNAME:$METASTORE_DB_PORT/$METASTORE_DB_NAME"
  