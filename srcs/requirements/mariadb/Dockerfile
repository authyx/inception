FROM debian:bookworm
RUN apt-get update && apt-get install -y mariadb-server
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
COPY init_db.sh /init_db.sh
RUN chmod +x /init_db.sh
EXPOSE 3306
CMD ["/init_db.sh"]