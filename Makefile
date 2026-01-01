# Created by yel-bouz (Yo-omega).

# Docker network and volume names
NETWORK_NAME = srcs_my_network
WP_VOLUME = srcs_wp_data
DB_VOLUME = srcs_db_data

# Environment variables for colors
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
RESET=\033[0m


all: build up

build:
	docker compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down


clean: down

full_cleanup:
	@echo ""
	@echo "${RED}WARNING: This will delete EVERYTHING related to this project!${RESET}"
	@echo "This includes:"
	@echo "   - All containers (nginx, wordpress, mariadb)"
	@echo "   - All volumes (wp_data, db_data) - ALL DATA WILL BE LOST"
	@echo "   - All custom images built for this project"
	@echo "   - Custom network (my_network)"
	@echo ""
	@read -p "Are you sure you want to delete everything? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo "${YELLOW}Performing full cleanup...${RESET}"; \
		docker compose -f srcs/docker-compose.yml down -v --rmi all; \
		echo "${GREEN}Full cleanup complete!${RESET}"; \
	else \
		echo "${RED}Cleanup cancelled.${RESET}"; \
	fi




re: clean build up

.PHONY: all build up down clean full_cleanup re
