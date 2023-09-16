# Makefile

.PHONY: all build-old build-new

all: build-old build-new

build-old:
	docker build --build-arg CLOUDFLARE_VERSION=2.8.15 -t certtest:old .

build-new:
	docker build --build-arg CLOUDFLARE_VERSION=2.11.6 -t certtest:new .

run-old:
	CERTBOT_IMAGE_NAME=certtest:old docker compose up

run-new:
	CERTBOT_IMAGE_NAME=certtest:new docker compose up

run-old-detached:
	CERTBOT_IMAGE_NAME=certtest:old docker compose up -d

run-new-detached:
	CERTBOT_IMAGE_NAME=certtest:new docker compose up -d

remove:
	docker compose down -v
	docker rmi certtest:old certtest:new