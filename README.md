*This project has been created as part of the 42 curriculum by yel-bouz*

# Description
this project is a Docker-based deployment of a web application stack including Nginx, MariaDB, and WordPress. It is designed to provide a local development environment that mimics a production setup.

# Instructions
1. Clone the repository to your local machine.
2. Navigate to the project directory.
3. Ensure you have Docker and Docker Compose installed on your machine.
4. Create a `.env` file in the root directory of the project and set the necessary environment variables as shown in the provided `.env.example` file.
5. Modify the `docker-compose.yml` file if necessary to suit your environment or requirements.
6. Run `make` to build and start the services.
7. Access the web application via your web browser at `https://localhost:443`.
8. To stop the services, run `make down`.

# Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress Documentation](https://wordpress.org/support/article/new-to-wordpress-where-to-start/)
- [WP-CLI Documentation](https://wp-cli.org/docs/)
- github dorking for the above stack components
- AI was used to assist in generating documentation and fixing minor script issues.

# Volumes
The project uses Docker volumes to persist data for the MariaDB database. This ensures that your database data is not lost when the containers are stopped or removed. The volume is defined in the `docker-compose.yml` file and is mounted to the appropriate directory in the MariaDB container.

# Project description
This project sets up a local web server environment using Docker containers. It includes the following components:
- Nginx: A high-performance web server that serves the WordPress site.
- MariaDB: A popular open-source database server that stores the WordPress data.
- WordPress: A widely-used content management system (CMS) for creating and managing websites.

The setup is orchestrated using Docker Compose, which allows for easy management of the multi-container application. The configuration files define the services, networks, and volumes required for the application to run smoothly.

> Docker vs VMs (based on our project):
- **Lightweight**: Docker containers share the host OS kernel, making them more lightweight compared to VMs that require a full OS for each instance.
- **Faster Startup**: Containers can start in seconds, while VMs may take minutes to boot up.
- **Resource Efficiency**: Containers use fewer resources since they share the host OS, allowing for higher density of applications on the same hardware.
- **Portability**: Docker containers can run consistently across different environments, while VMs may face compatibility issues due to differing hypervisors.
- **Isolation**: VMs provide stronger isolation since they run separate OS instances, while containers share the same OS kernel, which may lead to security concerns in multi-tenant environments.
- **Management**: Docker provides a more straightforward approach to application deployment and management through containerization, while VMs require more complex management of OS-level resources.

> Secrets vs Environment Variables:
- **Security**: Secrets are designed to be more secure than environment variables, as they are encrypted and managed by the orchestration tool (e.g., Docker Swarm, Kubernetes). Environment variables are stored in plain text and can be easily accessed by anyone with access to the container or host.
- **Lifecycle Management**: Secrets can be rotated and updated without restarting the application, while changes to environment variables typically require a container restart.
- **Access Control**: Secrets can have fine-grained access controls, allowing only specific services or containers to access them. Environment variables are accessible to any process running within the container.
- **Intended Use**: Secrets are intended for sensitive information such as passwords, API keys, and certificates, while environment variables are generally used for configuration settings that are not sensitive.
- **Storage**: Secrets are stored in a secure storage mechanism provided by the orchestration tool, while environment variables are stored in the container's environment.
>  Docker Network vs Host Network:
- **Isolation**: Docker networks provide isolation between containers, allowing them to communicate only with other containers on the same network. Host networks allow containers to share the host's network stack, which can lead to potential conflicts and security issues.
- **Port Mapping**: In Docker networks, containers can use port mapping to expose specific ports to the host. In host networks, containers use the host's ports directly, which can lead to port conflicts if multiple containers try to use the same port.
- **Performance**: Host networks can offer better performance for network-intensive applications since they bypass the Docker networking layer. However, this comes at the cost of isolation and security.
- **Use Cases**: Docker networks are suitable for most applications that require container-to-container communication, while host networks are typically used for applications that need direct access to the host's network, such as monitoring tools or network appliances.
> Docker Volumes vs Bind Mounts:
- **Management**: Docker volumes are managed by Docker and can be easily created, backed up, and migrated. Bind mounts are managed by the host system and require manual management.
- **Port	ability**: Docker volumes are portable across different Docker hosts, while bind mounts are tied to the specific host's filesystem structure.
- **Performance**: Docker volumes can offer better performance in certain scenarios, especially on non-Linux hosts, as they are optimized for Docker's use cases. Bind mounts may have performance overhead due to filesystem differences.
- **Use Cases**: Docker volumes are ideal for persisting data that needs to be shared between containers or backed up. Bind mounts are useful for development scenarios where you want to share code or configuration files between the host and the container.
