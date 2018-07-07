
# set ARGS=--no-cache
DEVICE_FLAG=--device=/dev/dri:/dev/dri


.PHONY: build
build:
	docker build $(ARGS) -t eth .

.PHONY: test
test:
	docker run --rm $(DEVICE_FLAG) eth:latest -G --list-devices

.PHONY: benchmark
benchmark:
	docker run --rm $(DEVICE_FLAG) eth:latest -G -M 0

.PHONY: run
run:
	docker run -dit --restart=unless-stopped $(DEVICE_FLAG) --name=eth eth:latest

.PHONY: shell
shell:
	docker run -it --rm $(DEVICE_FLAG) --entrypoint=/bin/bash eth:latest

