# Developer Documentation

## Prerequisites & Environment Setup
- OS: Linux VM (project must be done inside a VM).
- Tools: Docker, Docker Compose, Make.
- Clone repo; ensure `srcs/.env` is created (not committed) with DB/WP variables and `HOST_DATA_ROOT` (default `/home/yel-bouz/data`).
- (Optional) Create `/secrets/` (git-ignored) to store credentials if using Docker secrets.

## Build & Launch
From repository root:
- Build all images: `make build`
- Start stack (build if needed): `make up`
- Stop stack: `make down`
- Rebuild and restart: `make re`

## Managing Containers & Volumes
- Status: `cd srcs && docker compose ps`
- Logs: `cd srcs && docker compose logs -f <service>` (e.g., nginx, wordpress, mariadb)
- Shell inside container: `docker exec -it <container> sh` (or bash if available)
- Stop/remove containers: `cd srcs && docker compose down`
- Remove containers + volumes: `cd srcs && docker compose down -v`

## Data Locations & Persistence
- Bind-mounted host data root: `${HOST_DATA_ROOT}` (from `.env`, default `/home/yel-bouz/data`).
	- WordPress files: `${HOST_DATA_ROOT}/wp_data` (mounted to `/var/www/html`)
	- MariaDB data: `${HOST_DATA_ROOT}/db_data` (mounted to `/var/lib/mysql`)
- Docker volumes (named): `wp_data`, `db_data` (backed by the bind paths above).
- Config files:
	- `srcs/.env`: environment variables (domain, DB, WP users, HOST_DATA_ROOT)
	- `srcs/requirements/nginx/conf/nginx.conf`: nginx vhost & TLS settings
	- `srcs/requirements/wordpress/entrypoint.sh`: WordPress install/users bootstrap
	- `srcs/requirements/mariadb/init_db.sh`: DB initialization (users/db)
