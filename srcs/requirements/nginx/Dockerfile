FROM debian:bookworm
RUN apt-get update && apt-get install -y nginx
COPY conf /etc/nginx/sites-available/default
EXPOSE 443
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]