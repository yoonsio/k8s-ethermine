FROM ubuntu:18.04

MAINTAINER sickyoon <sick.yoon@gmail.com>
LABEL description="AMD OpenCL ethminer"

ARG amdgpu_ver=18.20-606296
ARG ethminer_ver=0.15.0rc2

ENV amdgpu_ver=$amdgpu_ver
ENV ethminer_ver=$ethminer_ver

WORKDIR /tmp

# install amd driver
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    #apt-get -y full-upgrade && \
    apt-get -y --no-install-recommends install \
      curl \
      ca-certificates \
      xz-utils
COPY amdgpu-pro-${amdgpu_ver}.tar.xz /tmp/amdgpu-pro-${amdgpu_ver}.tar.xz
RUN ls -al /tmp/amdgpu-pro-${amdgpu_ver}.tar.xz
RUN tar -Jxvf /tmp/amdgpu-pro-${amdgpu_ver}.tar.xz
RUN /tmp/amdgpu-pro-${amdgpu_ver}/amdgpu-pro-install -y --headless --opencl=legacy
RUN apt-get -y autoremove
RUN apt-get -y autoclean
RUN rm -rf /var/lib/{apt,dpkg,cache,log}

# install ethminer
RUN curl -L -O https://github.com/ethereum-mining/ethminer/releases/download/v${ethminer_ver}/ethminer-${ethminer_ver}-Linux.tar.gz
RUN tar -xvf ethminer-${ethminer_ver}-Linux.tar.gz
RUN rm ethminer-${ethminer_ver}-Linux.tar.gz
RUN mv bin/ethminer /usr/local/bin/ethminer
RUN rm -r bin

ENV GPU_FORCE_64BIT_PTR 1
ENV GPU_MAX_HEAP_SIZE 100
ENV GPU_USE_SYNC_OBJECTS 1
ENV GPU_MAX_ALLOC_PERCENT 100
ENV GPU_SINGLE_ALLOC_PERCENT 100

ENTRYPOINT ["/usr/local/bin/ethminer"]
CMD [ \
  "-R", \
  "-G", \ 
  "--tstop", "80", \
  "--tstart", "74", \
  "-P", \
  "stratum+ssl://0xd0f4bb2257e7e686255881bf0520240c3b862628@us1.ethermine.org:5555", \
  "stratum+ssl://0xd0f4bb2257e7e686255881bf0520240c3b862628@us2.ethermine.org:5555" \
]

