# Created by yel-bouz.

all: build

build:
	cd srcs && docker-compose build

up:
	cd srcs && docker-compose up -d

down:
	cd srcs && docker-compose down

clean: down

iamverysurewanttodeletethis:
	cd srcs && docker-compose down -v

re: clean build up

.PHONY: all build up down clean re
