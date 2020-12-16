FROM ubuntu:20.04

MAINTAINER sickyoon <sick.yoon@gmail.com>
LABEL description="AMD OpenCL ethminer"

ARG amdgpu_ver=20.45-1164792-ubuntu-20.04
ARG ethminer_ver=0.18.0
ARG ethminer_file=ethminer-${ethminer_ver}-cuda-9-linux-x86_64.tar.gz

WORKDIR /tmp

# install tools
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    xz-utils \
    tzdata

# RUN dpkg --add-architecture i386 && \
#     apt-get update && \
#     apt-get -y --no-install-recommends install \
#     curl \
#     ca-certificates \
#     xz-utils \
#     initramfs-tools

# install ethminer
RUN curl -L -O https://github.com/ethereum-mining/ethminer/releases/download/v${ethminer_ver}/${ethminer_file}
RUN tar -xvf ${ethminer_file}
RUN rm ${ethminer_file}
RUN mv bin/* /usr/local/bin/.
RUN rm -r bin

# install amd driver
RUN curl --output /tmp/amdgpu-pro-${amdgpu_ver}.tar.xz --referer https://www.amd.com/en/support/graphics/radeon-500-series/radeon-rx-500-series/radeon-rx-580 https://drivers.amd.com/drivers/linux/amdgpu-pro-${amdgpu_ver}.tar.xz
RUN tar -Jxvf /tmp/amdgpu-pro-${amdgpu_ver}.tar.xz
RUN /tmp/amdgpu-pro-${amdgpu_ver}/amdgpu-pro-install -y --headless --opencl=legacy,pal
RUN apt-get -y autoremove
RUN apt-get -y autoclean
RUN rm -rf /var/lib/{apt,dpkg,cache,log}

ENV GPU_FORCE_64BIT_PTR=1
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100

# ENTRYPOINT ["/usr/local/bin/ethminer"]
