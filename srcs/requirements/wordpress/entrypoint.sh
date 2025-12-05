#!/bin/bash
set -e

# Copy WordPress files to volume if not already present
if [ ! -f "/var/www/html/index.php" ]; then
    echo "[wordpress] Installing WordPress to /var/www/html"
    cp -r /wordpress/* /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# Wait for MariaDB to be ready
echo "[wordpress] Waiting for MariaDB..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
    sleep 1
done
echo "[wordpress] MariaDB is ready"

# Configure wp-config.php if it doesn't exist
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "[wordpress] Configuring wp-config.php"
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" /var/www/html/wp-config.php
    
    # Add unique keys and salts
    SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    printf '%s\n' "g?define('AUTH_KEY'?d" "i" "$SALT" "." "wq" | ed -s /var/www/html/wp-config.php 2>/dev/null || true
fi

echo "[wordpress] Starting PHP-FPM"
exec php-fpm8.2 -F
