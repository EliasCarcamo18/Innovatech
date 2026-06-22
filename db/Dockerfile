# Imagen base MySQL 8 oficial
FROM mysql:8

# Crear la base de datos automáticamente al iniciar el contenedor
ENV MYSQL_DATABASE=innovatech_db

# Copiar el script de inicialización
COPY init.sql /docker-entrypoint-initdb.d/

# Exponer el puerto de MySQL
EXPOSE 3306