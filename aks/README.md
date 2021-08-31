# AKS definitions

1. `vbserver-as-pods.yaml`: contains the pod definitions and the services to expose the pods
2. `monitor-targets.yaml`: to define the prometheus targets for the pods

> For monitoring run this helm chart before applying the monitor-targets.yaml:
```sh
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring --set prometheus-node-exporter.nodeSelector."beta\.kubernetes\.io/os"=linux --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
```
