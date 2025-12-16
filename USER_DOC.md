# Services
This stack runs three containers:
- **Nginx**: TLS (443) reverse proxy serving the WordPress site.
- **WordPress (php-fpm)**: Handles PHP rendering for the site.
- **MariaDB**: Stores the WordPress database.

# Start & Stop the project
From the repository root:
- Start (build + run): `make up`
- Stop (keep volumes): `make down`
- Rebuild and restart: `make re`

# Accessing the site and admin
- Website: https://yel-bouz.1337.ma (or https://localhost if no DNS/hosts entry)
- Admin panel: https://yel-bouz.1337.ma/wp-admin

# Credentials (location & management)
- Environment values are in `srcs/.env` (should NOT be committed to git).
- Database and WP data live on host bind mounts at `${HOST_DATA_ROOT}` (default `/home/yel-bouz/data`):
	- WordPress files: `${HOST_DATA_ROOT}/wp_data`
	- MariaDB data: `${HOST_DATA_ROOT}/db_data`
- If using secrets, store them in `/secrets/` (git-ignored).

# Checking service health
- Container status: `cd srcs && docker compose ps`
- Nginx reachability: `curl -k -I https://localhost`
- WordPress running: open the site or `curl -k https://localhost | head`
- Logs (by service): `cd srcs && docker compose logs <service>` (e.g., nginx, wordpress, mariadb)


