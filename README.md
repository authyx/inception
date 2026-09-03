*Built as part of the 42 curriculum by authyx.*

# Description

This project is a **Docker-based deployment** of a web application stack with **Nginx**, **MariaDB**, and **WordPress**. It provides a fully containerized local development and production-ready environment that mimics a real-world web server setup.

**Tech stack:** Docker, Docker Compose, Nginx, MariaDB, WordPress, TLS (self-signed), Debian bookworm.

## What I learned

Learned Docker end-to-end: containerizing services, wiring them together on a custom bridge network, managing secrets properly (Docker secrets for credentials, `.env` for non-sensitive config — never commit passwords), and setting up TLS on Nginx. The architecture comparison section (containers vs VMs, bridge vs host network, volumes vs bind mounts) comes from actually having to make those choices and justify them — not just reading about them. Set up WordPress + MariaDB + Nginx from scratch with no pre-made images beyond the official base ones.

**Goal**: Learn and practice Docker concepts by building a multi-container infrastructure with networking, volumes, and environment management.

# Instructions

**Prerequisites**:
- Docker & Docker Compose installed
- Make utility
- Linux VM

**Setup & Execution**:
1. Clone the repository: `git clone <repo-url>`
2. Navigate to project root: `cd inception`
3. Create `srcs/.env` file with required variables (see `USER_DOC.md`)
4. Build and start services: `make up` (equivalent to `make build && make up`)
5. Access WordPress at: `https://localhost`
6. Access WordPress admin at: `https://localhost/wp-admin`
7. Stop services: `make down`
8. For more commands: see `USER_DOC.md` and `DEV_DOC.md`

# Resources

**Documentation & References**:
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress Documentation](https://wordpress.org/support/)
- [WP-CLI Documentation](https://wp-cli.org/docs/)
- 42 Intra Project Specification

**AI Usage**:
AI was used to:
- Review Docker configuration best practices
- Help with shell scripts (entrypoint.sh, init_db.sh)
- optimize documentation (README.md, USER_DOC.md, DEV_DOC.md)

All AI-generated code was reviewed, tested, and verified to ensure correctness and adherence to project requirements.

# Project Architecture

This stack deploys three independent containerized services:
- **Nginx** (port 443 TLS): Reverse proxy and static asset server
- **WordPress + PHP-FPM** (port 9000 internal): CMS application logic
- **MariaDB** (port 3306 internal): Relational database

Services communicate via a custom Docker bridge network (`my_network`). Data persists using named Docker volumes backed by host bind mounts.

## Design Choices
- **Debian:bookworm** base images for stability and security
- **TLSv1.2/TLSv1.3 only** for security
- **Environment variables + .env** for configuration management
- **Bind-mounted volumes** for host data access during development
- **WP-CLI** for automated WordPress setup and user management
- **restart: always** policy for fault tolerance

## Architecture Comparisons
In this project, Docker containers:
- **Share** the host OS kernel → lightweight, fast startup
- **Use less** system resources → multiple containers per host
- **Deploy faster** → seconds vs minutes for VMs
- **Trade-off**: Weaker isolation than VMs (acceptable for development)

This makes Docker ideal for development and lightweight deployments.

### Secrets vs Environment Variables
In this project:
- **Environment variables** (`.env`): Used for non-sensitive config (domain, database names, usernames). Must NOT be committed to git.
- **Docker secrets** (`/secrets/`): Used for all passwords and sensitive data (DB passwords, WP passwords). Each secret file contains **only the password string** (one value per file) and is mounted to `/run/secrets/` inside containers. Git-ignored for security.

**Choice**: We use Docker secrets for all credentials and `.env` for non-sensitive configuration.
### Docker Network vs Host Network
In this project:
- **Custom bridge network** (`my_network`): Services communicate securely, isolated from host. Each service gets a hostname (nginx, wordpress, mariadb). **Used here.**
- **Host network**: Containers share host's network stack. Faster but less secure and prone to port conflicts.

**Choice**: We use a custom bridge network for multi-container isolation and service discovery.
### Docker Volumes vs Bind Mounts
In this project:
- **Named volumes** (`wp_data`, `db_data`): Managed by Docker, backed by host bind mounts for development. **Used here.**
- **Pure bind mounts**: Direct host path → container. Less portable, ties data to specific host location.
- **Docker volumes only**: Fully managed but no direct host access.

**Choice**: We use named volumes with bind-mount backing for both Docker management and host filesystem access during development.
