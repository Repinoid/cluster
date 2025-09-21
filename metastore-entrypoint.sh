#!/bin/sh
set -e

# Установка classpath из hadoop command
echo "Setting up Hadoop and Hive classpath..."
export HADOOP_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath --glob):/opt/hive/lib/*
export CLASSPATH=$HADOOP_CLASSPATH
export HADOOP_HOME=/opt/hadoop

# Создаем директорию если не существует
if [ ! -d "/home/hive" ]; then
    echo "Creating /home/hive directory..."
    mkdir -p /home/hive
    chown hive:hive /home/hive
    chmod 755 /home/hive
fi

# Детальная проверка доступности S3AFileSystem
echo "Per detailed S3AFileSystem class check..."
cat > /tmp/TestS3A.java << 'EOF'
import org.apache.hadoop.fs.s3a.S3AFileSystem;
public class TestS3A {
    public static void main(String[] args) {
        try {
            Class<?> clazz = Class.forName("org.apache.hadoop.fs.s3a.S3AFileSystem");
            System.out.println("SUCCESS: S3AFileSystem class found: " + clazz.getName());
            
            // Дополнительная проверка - создание экземпляра
            try {
                Object instance = clazz.newInstance();
                System.out.println("SUCCESS: S3AFileSystem instance created");
            } catch (Exception e) {
                System.out.println("INFO: S3AFileSystem instance creation failed (expected): " + e.getMessage());
            }
            
        } catch (ClassNotFoundException e) {
            System.out.println("ERROR: S3AFileSystem class not found: " + e.getMessage());
            System.exit(1);
        }
    }
}
EOF

# Компилируем и запускаем проверку
javac -cp "$CLASSPATH" /tmp/TestS3A.java && \
java -cp "/tmp:$CLASSPATH" TestS3A

# Очищаем временные файлы
rm -f /tmp/TestS3A.java /tmp/TestS3A.class

echo "Classpath validation completed successfully"

# Запускаем Hive Metastore сервис
echo "Starting Hive Metastore service on port 9083..."
exec /opt/hive/bin/hive --service metastore -p 9083