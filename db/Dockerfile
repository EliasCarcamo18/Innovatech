FROM mysql:8

ENV MYSQL_DATABASE=innovatech_db

COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306