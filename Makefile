
# set ARGS=--no-cache
DEVICE_FLAG=--device=/dev/dri:/dev/dri

.PHONY: build
build:
	docker build $(ARGS) -t sickyoon/ethminer-amd .

.PHONY: test
test:
	docker run --rm $(DEVICE_FLAG) sickyoon/ethminer-amd:latest -G --list-devices

.PHONY: benchmark
benchmark:
	docker run --rm $(DEVICE_FLAG) sickyoon/ethminer-amd:latest -G -M 1

.PHONY: run
run:
	docker run -dit --restart=unless-stopped $(DEVICE_FLAG) --name=ethminer-amd sickyoon/ethminer-amd:latest

.PHONY: shell
shell:
	docker run -it --rm $(DEVICE_FLAG) --entrypoint=/bin/bash sickyoon/ethminer-amd:latest

.PHONY: install
install:
	helm install eth --debug ./chart/.

