FROM debian:bookworm

RUN apt-get update -y && apt-get install mariadb-server -y && \
    rm -rf /var/lib/apt/lists/*

# Configure MariaDB to listen on all interfaces
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Prepare directories
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

COPY init_db.sh /init_db.sh
RUN chmod +x /init_db.sh

EXPOSE 3306

CMD ["/init_db.sh"]