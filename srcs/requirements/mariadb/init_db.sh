# Start mariadb daemon in background without networking for initialization
mariadbd --skip-networking &

# Wait for the server to be up
sleep 5

# Execute SQL commands to create database, user, and grant privileges
mysql -uroot <<-EOSQL
  CREATE DATABASE IF NOT EXISTS `${MARIADB_DATABASE}`;
  CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
  GRANT ALL PRIVILEGES ON `${MARIADB_DATABASE}`.* TO '${MARIADB_USER}'@'%';
  FLUSH PRIVILEGES;
EOSQL

# After your SQL commands, add:
mysqladmin -uroot shutdown

# Then start the final process:
exec mariadbd --user=mysql