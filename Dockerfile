FROM ubuntu:20.04

MAINTAINER sickyoon <sick.yoon@gmail.com>
LABEL description="AMD OpenCL ethminer"

# https://drivers.amd.com/drivers/linux/amdgpu-pro-21.30-1290604-ubuntu-20.04.tar.xz
# https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-9-linux-x86_64.tar.gz

ARG amdgpu_ver=21.30-1290604-ubuntu-20.04
ARG ethminer_ver=0.18.0
ARG ethminer_file=ethminer-${ethminer_ver}-cuda-9-linux-x86_64.tar.gz

ENV amdgpu_ver=$amdgpu_ver
ENV ethminer_ver=$ethminer_ver

WORKDIR /tmp

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
    curl \
    ca-certificates \
    xz-utils \
    initramfs-tools \
    jq

# install ethminer
RUN curl -L -O https://github.com/ethereum-mining/ethminer/releases/download/v${ethminer_ver}/${ethminer_file}
RUN tar -xvf ${ethminer_file}
RUN rm ${ethminer_file}
RUN mv bin/* /usr/local/bin/.
RUN rm -r bin

# install nsfminer
RUN curl -L -O https://github.com/no-fee-ethereum-mining/nsfminer/releases/download/v1.3.14/nsfminer_1.3.14-ubuntu_20.04-cuda_11.3-opencl.tgz
RUN tar -xvf nsfminer_1.3.14-ubuntu_20.04-cuda_11.3-opencl.tgz
RUN rm nsfminer_1.3.14-ubuntu_20.04-cuda_11.3-opencl.tgz
RUN mv nsfminer /usr/local/bin/.

# install amd driver
RUN curl --output /tmp/amdgpu-pro-${amdgpu_ver}.tar.xz --referer https://www.amd.com/en/support/graphics/radeon-500-series/radeon-rx-500-series/radeon-rx-580 https://drivers.amd.com/drivers/linux/amdgpu-pro-${amdgpu_ver}.tar.xz
RUN tar -Jxvf /tmp/amdgpu-pro-${amdgpu_ver}.tar.xz
RUN /tmp/amdgpu-pro-${amdgpu_ver}/amdgpu-pro-install -y --headless --opencl=legacy,rocm
RUN apt-get -y autoremove
RUN apt-get -y autoclean
RUN rm -rf /var/lib/{apt,dpkg,cache,log}

RUN export GPU_FORCE_64BIT_PTR=1
RUN export GPU_MAX_HEAP_SIZE=100
RUN export GPU_USE_SYNC_OBJECTS=1
RUN export GPU_MAX_ALLOC_PERCENT=100
RUN export GPU_SINGLE_ALLOC_PERCENT=100

ENTRYPOINT ["/usr/local/bin/nsfminer"]
