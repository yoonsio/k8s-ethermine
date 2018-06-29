
# DockerEthermine

Run ethermine in Docker!

amdgpu-pro driver must be downloaded from amd website.

## Rebuilding Image (without cache)

```
make build ARGS=--no-cache
```

## Specifying version

```
make build ARGS="--no-cache \
  --build-arg amdgpu_ver=18.20-606296 \
  --build-arg ethminer_ver=0.15.0rc2"
```

## Benchmark
```
make benchmark
```

