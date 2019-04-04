#!/bin/sh

# Author: Lowry
# Time: 2018/10/14

namespace="monitoring"			# TODO(可选)
image_registry="dr.edit.io\/k8s"    	# TODO(必须)

nfs_host="127.0.0.1"			# TODO(必须)
nfs_dir="\/opt\/prometheus"		# TODO(必须)

# -------------------------------------
# create namespace
kubectl create namespace $namespace

function editImage()
{
    sed -i "s/namespace: monitoring/namespace: $namespace/g" grafana-pvc.yaml
    sed -i "s/namespace: monitoring/namespace: $namespace/g" prometheus-pvc.yaml
    sed -i "s/namespace: monitoring/namespace: $namespace/g" prometheus-operator-base.yaml
    sed -i "s/namespace: monitoring/namespace: $namespace/g" manifests/alertmanager/*
    sed -i "s/namespace: monitoring/namespace: $namespace/g" manifests/grafana/*
    sed -i "s/namespace: monitoring/namespace: $namespace/g" manifests/kube-state-metrics/*
    sed -i "s/namespace: monitoring/namespace: $namespace/g" manifests/node-exporter/*
    sed -i "s/namespace: monitoring/namespace: $namespace/g" manifests/prometheus/*
    sed -i "s/namespace: monitoring/namespace: $namespace/g" manifests/prometheus-crd/*
    sed -i "s/namespace: monitoring/namespace: $namespace/g" manifests/prometheus-operator/*
    sed -i "s/quay.io\/coreos/$image_registry/g" manifests/alertmanager/*
    sed -i "s/quay.io\/coreos/$image_registry/g" manifests/grafana/*
    sed -i "s/quay.io\/coreos/$image_registry/g" manifests/kube-state-metrics/*
    sed -i "s/quay.io\/coreos/$image_registry/g" manifests/node-exporter/*
    sed -i "s/quay.io\/coreos/$image_registry/g" manifests/prometheus/*
    sed -i "s/quay.io\/coreos/$image_registry/g" manifests/prometheus-crd/*
    sed -i "s/quay.io\/coreos/$image_registry/g" manifests/prometheus-operator/*
    sed -i "s/quay.io\/prometheus/$image_registry/g" manifests/alertmanager/*
    sed -i "s/quay.io\/prometheus/$image_registry/g" manifests/node-exporter/*
    sed -i "s/quay.io\/prometheus/$image_registry/g" manifests/prometheus/*
    sed -i "s/image: grafana/image: $image_registry/g" manifests/grafana/grafana-deployment.yaml
}

# instead .yaml registry address(TODO)
editImage
sleep 2

# create pv and pvc(TODO)
sed -i "s/127.0.0.1/$nfs_host/g" ./prometheus-pvc.yaml
sed -i "s/127.0.0.1/$nfs_host/g" ./grafana-pvc.yaml
sed -i "s/\/opt\/nfsserver/$nfs_dir/g" ./prometheus-pvc.yaml
sed -i "s/\/opt\/nfsserver/$nfs_dir/g" ./grafana-pvc.yaml
kubectl create -f ./prometheus-pvc.yaml
kubectl create -f ./grafana-pvc.yaml
sleep 2

# install prometheus-crd
echo "--------  Deploying Prometheus CRD"
kubectl create -f manifests/prometheus-crd

# install promethes-operator
echo "-------- Deploying Prometheus Operator"
kubectl create -f manifests/prometheus-operator

# install alertmanager
echo "-------- Deploying alertmanager"
kubectl create -f manifests/alertmanager

# install node-exporter
echo "-------- Deploying node-exporter"
kubectl create -f manifests/node-exporter

# install kube-state-metrics
echo "-------- Deploying kube-state-metrics"
kubectl create -f manifests/kube-state-metrics

# install prometheus
echo "-------- Deploying prometheus"
kubectl create -f manifests/prometheus

# install grafana
echo "-------- Deploying grafana"
kubectl create -f manifests/grafana

# install k8s svc
echo "-------- Deploying k8s svc"
kubectl create -f manifests/k8s


exit 0
