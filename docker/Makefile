include ../.env
export $(shell sed 's/=.*//' ../.env)

.PHONY : image
image:
	docker build -t $(DOCKER_IMAGE) .

.PHONY : exec
exec:
	docker run --rm -it -v $(PWD):/mnt -w /mnt $(DOCKER_IMAGE) sh
