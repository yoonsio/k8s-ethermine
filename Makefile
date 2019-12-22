
# set ARGS=--no-cache
DEVICE_FLAG=--device=/dev/dri:/dev/dri

.PHONY: build
build:
	docker build $(ARGS) -t ethminer-amd .

.PHONY: test
test:
	docker run --rm $(DEVICE_FLAG) ethminer-amd:latest -G --list-devices

.PHONY: benchmark
benchmark:
	docker run --rm $(DEVICE_FLAG) ethminer-amd:latest -G -M 7900888

.PHONY: run
run:
	docker run -dit --restart=unless-stopped $(DEVICE_FLAG) --name=ethminer-amd ethminer-amd:latest

.PHONY: shell
shell:
	docker run -it --rm $(DEVICE_FLAG) --entrypoint=/bin/bash ethminer-amd:latest

.PHONY: install
install:
	helm install eth --debug ./chart/.

