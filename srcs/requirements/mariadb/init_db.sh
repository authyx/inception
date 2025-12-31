#!/bin/bash
set -e

# Read passwords from Docker secrets
if [ -f "$MARIADB_PASSWORD_FILE" ]; then
    MARIADB_PASSWORD=$(cat "$MARIADB_PASSWORD_FILE")
fi
if [ -f "$MARIADB_ROOT_PASSWORD_FILE" ]; then
    MARIADB_ROOT_PASSWORD=$(cat "$MARIADB_ROOT_PASSWORD_FILE")
fi

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[init] Initializing MariaDB data directory"
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL temporarily for setup
echo "[init] Starting MariaDB for configuration"
mysqld --user=mysql --bootstrap --skip-networking <<-EOSQL
    USE mysql;
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

echo "[init] Starting MariaDB server"
exec mysqld --user=mysql --datadir=/var/lib/mysql