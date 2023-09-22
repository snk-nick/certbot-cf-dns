# Variables
OLD_IMAGE = certtest:old
NEW_IMAGE = certtest:new

# Default goal
.DEFAULT_GOAL := all

# Phony targets
.PHONY: all build-old build-new run-old run-new run-old-detached run-new-detached remove help

# Help message
help:
	@echo "Available targets:"
	@echo "  all           Build old and new images"
	@echo "  build-old     Build certtest:old image"
	@echo "  build-new     Build certtest:new image"
	@echo "  run-old       Run old image"
	@echo "  run-new       Run new image"
	@echo "  remove        Shut down containers"
	@echo "  purge         Purge containers, networks, volumes, and images"

# Targets
all: build-old build-new

build-old:
	docker build --build-arg CLOUDFLARE_VERSION=2.8.15 -t $(OLD_IMAGE) .

build-new:
	docker build --build-arg CLOUDFLARE_VERSION=2.11.7 -t $(NEW_IMAGE) .

run-old:
	CERTBOT_IMAGE_NAME=$(OLD_IMAGE) docker compose up

run-new:
	CERTBOT_IMAGE_NAME=$(NEW_IMAGE) docker compose up

run-old-detached:
	CERTBOT_IMAGE_NAME=$(OLD_IMAGE) docker compose up -d

run-new-detached:
	CERTBOT_IMAGE_NAME=$(NEW_IMAGE) docker compose up -d

remove: 
	docker compose down
	
purge:
	@sh -c " \
		docker compose down -v && \
		docker rmi $(OLD_IMAGE) $(NEW_IMAGE) && \
		docker ps -a --filter 'ancestor=$(OLD_IMAGE)' --format '{{.ID}}' | xargs -r docker rm -f && \
		docker ps -a --filter 'ancestor=$(NEW_IMAGE)' --format '{{.ID}}' | xargs -r docker rm -f && \
		echo 'There may be additional files left on your system, consider the following commands:' && \
		echo '  docker image prune -f' && \
		echo '  docker volume prune -f' && \
		echo '  docker builder prune -f' && \
		echo '  docker container prune -f' && \
		echo 'However, please note these are system-wide commands and may affect other images/builds.' \
	"