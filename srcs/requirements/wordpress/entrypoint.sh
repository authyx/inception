#!/bin/bash
set -e

# Read passwords from Docker secrets
if [ -f "$WORDPRESS_DB_PASSWORD_FILE" ]; then
    WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
fi
if [ -f "$WP_ADMIN_PASSWORD_FILE" ]; then
    WP_ADMIN_PASSWORD=$(cat "$WP_ADMIN_PASSWORD_FILE")
fi
if [ -f "$WP_USER_PASSWORD_FILE" ]; then
    WP_USER_PASSWORD=$(cat "$WP_USER_PASSWORD_FILE")
fi

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

# Change to WordPress directory
cd /var/www/html

# Configure wp-config.php if it doesn't exist
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "[wordpress] Creating wp-config.php"
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "[wordpress] Installing WordPress core"
    wp core install \
        --url="${WP_SITE_URL}" \
        --title="${WP_SITE_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
    
    echo "[wordpress] WordPress installation complete"
fi

# Create admin user if it doesn't exist
if ! wp user get "${WP_ADMIN_USER}" --allow-root 2>/dev/null; then
    echo "[wordpress] Creating admin user: ${WP_ADMIN_USER}"
    wp user create \
        "${WP_ADMIN_USER}" \
        "${WP_ADMIN_EMAIL}" \
        --user_pass="${WP_ADMIN_PASSWORD}" \
        --role=administrator \
        --allow-root
fi

# Create regular user if it doesn't exist
if ! wp user get "${WP_USER}" --allow-root 2>/dev/null; then
    echo "[wordpress] Creating regular user: ${WP_USER}"
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=editor \
        --allow-root
fi

# Display user information
echo "[wordpress] WordPress users:"
wp user list --allow-root --format=table

# Ensure correct permissions
chown -R www-data:www-data /var/www/html

echo "[wordpress] Starting PHP-FPM"
exec php-fpm8.2 -F
