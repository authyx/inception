FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-client \
    php \
    php-fpm \
    php-mysql \
    php-curl \
    php-mbstring \
    php-xml \
    php-zip \
    wget \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Download WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz && \
    rm latest.tar.gz

# Configure php-fpm
RUN sed -i 's/;listen\.owner/listen.owner/' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/;listen\.group/listen.group/' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/;listen\.mode/listen.mode/' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/listen = .*/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]