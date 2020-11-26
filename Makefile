all: usage

export GNUMAKEFLAGS=--no-print-directory
SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c

ifeq (,$(wildcard ./.env))
$(error ".env not found: copy .env.sample and edit it for your environment")
endif

include .env
export $(shell cat .env | tr -d '"' | sed 's/=.*//')

NUM ?= 3
export NUM

# internal variables
UID := $(shell id -u)
GID := $(shell id -g)
DOCKER=docker run --rm -u "${UID}" -v "`pwd`:/mnt" -v /etc/localtime:/etc/localtime:ro -w /mnt --env-file .env -e NUM="$(NUM)" "${DOCKER_IMAGE}"


docker-image:
ifeq (,$(shell docker image ls -q "${DOCKER_IMAGE}"))
	@echo "Docker image[${DOCKER_IMAGE}] not found. Creating..."
	make -C docker
	@echo "Created docker image[${DOCKER_IMAGE}]. Try the task again."
	@exit 0
endif
	@:

ruby/%: docker-image
	@${DOCKER} time ruby "$(shell basename '$*' .rb).rb"

######################################################################
### main

usage: docker-image
	@echo "Possible queue operations:"
	@echo "  make info      # Show information of the queue"
	@echo "  make send NUM=$(NUM)  # Produce $(NUM) messages into the queue"
	@echo "  make recv NUM=$(NUM)  # Consume $(NUM) messages from the queue"
	@echo ""
	@echo "Executing 'make info'..."
	@make info

info:
	@make ruby/info

send:
	@make ruby/send

recv:
	@make ruby/recv
