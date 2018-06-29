
# k8s-ethermine

Run ethermine in Kubernetes!

amdgpu-pro driver must be downloaded from amd website.

## Run local docker registry
```
docker run -d -p 5000:5000 --name registry registry:2
```

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

## start docker registry
```
docker run -d -p 5000:5000 --restart=always --name=registry registry:2
```

## k8s deploy
```
sudo swapoff -a
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

## k8s init
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
```

## helm install
```
# optional - in case tainted error
kubectl taint nodes --all node-role.kubernetes.io/master-
helm init --upgrade
```

## helm permission
```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade
helm update repo .
```

## enable k8s gpu plugin
https://github.com/RadeonOpenCompute/k8s-device-plugin
```
kubectl create -f k8s-ds-amdgpu-dp.yaml
```

## deploy helm
```
helm install --dry-run --debug ./chart
```

## k8s teardown
```
kubectl drain secret --delete-local-data --force --ignore-daemonsets
kubectl delete node secret
kubeadm reset
```

