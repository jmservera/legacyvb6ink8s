# AKS definitions

1. `vbserver-as-pods.yaml`: contains the pod definitions and the services to expose the pods. The vbserver pods contain one container that runs a tcp server, and also runs two Prometheus Exporters: the [Windows Exporter][windows_exporter] that publishes WMI data and the [Grok Exporter][grok_exporter] that creates metrics based on the log files.

2. `monitor-targets.yaml`: to define the prometheus targets for monitoring the pods. This is the new way used by the [Prometheus Operator][prometheus_operator].

> For monitoring run this helm chart before applying the monitor-targets.yaml:
```sh
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring \
    --set prometheus-node-exporter.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
    --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
```

3. `helm` folder: contains an example helm template to deploy this application using [Helm][helm]
4. `kustomize` folder: contains an example template to deploy multiple pods and services for this app using Kustomize. You can deploy the full app using this command inside the `kustomize` folder:

    ```bash
    kubectl apply -k .
    ```
    or you can also see what it will be created by running
    ```bash
    kubectl kustomize .
    ```

[grok_exporter]:https://github.com/fstab/grok_exporter
[helm]: https://helm.sh/
[prometheus_operator]: https://github.com/prometheus-operator/prometheus-operator
[windows_exporter]:https://github.com/prometheus-community/windows_exporter