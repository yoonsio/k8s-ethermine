
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
	docker run --rm $(DEVICE_FLAG) --name=ethminer-amd sickyoon/ethminer-amd:latest 

.PHONY: mine
mine:
	docker run --rm $(DEVICE_FLAG) --name=ethminer-amd sickyoon/ethminer-amd:latest -R -G --tstop 80 --tstart 74 -P stratum+ssl://0xd0f4bb2257e7e686255881bf0520240c3b862628@us1.ethermine.org:5555

.PHONY: shell
shell:
	docker run -it --rm $(DEVICE_FLAG) --entrypoint=/bin/bash sickyoon/ethminer-amd:latest

.PHONY: install
install:
	helm install eth --debug ./chart/.

