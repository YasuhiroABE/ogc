
DOCKER_CMD = podman
DOCKER_BUILDER = mabuilder

NAME = my-ogc
DOCKER_IMAGE = my-ogc
DOCKER_IMAGE_VERSION = 7.11.0
IMAGE_NAME = $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)
REGISTRY_SERVER = docker.io
REGISTRY_LIBRARY = yasuhiroabe

PROD_IMAGE_NAME = $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME)

.PHONY: all
all:
	@echo "Please specify a target: make [run|docker-build|docker-build-prod|docker-push|docker-run|docker-stop|check|clean]"

.PHONY: docker-build
docker-build:
	$(DOCKER_CMD) build . --tag $(DOCKER_IMAGE):latest

.PHONY: docker-build-prod
docker-build-prod:
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME) --no-cache

.PHONY: docker-tag
docker-tag:
	$(DOCKER_CMD) tag $(IMAGE_NAME) $(PROD_IMAGE_NAME)

.PHONY: docker-push
docker-push:
	$(DOCKER_CMD) push $(PROD_IMAGE_NAME)

.PHONY: docker-run
docker-run:
	$(DOCKER_CMD) run -it --rm \
		-v `pwd`/test:/local \
		$(DOCKER_IMAGE):latest generate -g ruby-sinatra -o code -i openapi.yaml

.PHONY: docker-stop
docker-stop:
	$(DOCKER_CMD) stop $(NAME)

.PHONY: clean
clean:
	find . -name '*~' -type f -exec rm {} \; -print

.PHONY: docker-buildx-init
docker-buildx-init:
	$(DOCKER_CMD) buildx create --name $(DOCKER_BUILDER) --use

.PHONY: docker-buildx-setup
docker-buildx-setup:
	$(DOCKER_CMD) buildx use $(DOCKER_BUILDER)
	$(DOCKER_CMD) buildx inspect --bootstrap

.PHONY: docker-buildx-prod
docker-buildx-prod:
	$(DOCKER_CMD) buildx build --platform linux/amd64,linux/arm64 --tag $(PROD_IMAGE_NAME) --no-cache --push .

.PHONY: docker-runx
docker-runx:
	$(DOCKER_CMD) run -it --rm  \
		--env LC_CTYPE=ja_JP.UTF-8 \
		-p $(PORT):8080 \
		--name $(NAME) \
		$(PROD_IMAGE_NAME)
