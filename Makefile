# Created by yel-bouz.

SRCS_DIR	=	srcs/

all : build

build :
	docker build -t inception .

run :
	docker run -d -p 80:80 --name inception inception

stop :
	docker stop inception

clean :
	docker rm -f inception
	docker rmi -f inception

reload : stop clean build run

.PHONY : all build run stop clean reload
