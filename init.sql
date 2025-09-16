-- Создание базы данных, если она не существует
SELECT 'CREATE DATABASE metastore_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'metastore_db')\gexec

-- Создание пользователя muser и назначение прав
-- CREATE USER muser WITH PASSWORD 'mpassword';
-- ALTER USER muser WITH SUPERUSER;

-- Предоставление всех прав пользователю muser на базу данных metastore_db
GRANT ALL PRIVILEGES ON DATABASE metastore_db TO muser;

-- Подключение к базе данных и установка прав
\c metastore_db;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO muser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO muser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO muser;
