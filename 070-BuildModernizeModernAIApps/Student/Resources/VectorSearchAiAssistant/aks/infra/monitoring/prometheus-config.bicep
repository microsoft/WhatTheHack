@secure()
param kubeConfig string

import 'kubernetes@1.0.0' with {
  namespace: 'kube-system'
  kubeConfig: kubeConfig
}

resource coreConfigMap_amaMetricsPrometheusConfig 'core/ConfigMap@v1' = {
  metadata: {
    name: 'ama-metrics-prometheus-config'
    namespace: 'kube-system'
  }
  data: {
    'prometheus-config': 'global:\n  scrape_interval: 15s\nscrape_configs:\n- job_name: \'kubernetes-pods\'\n  kubernetes_sd_configs:\n  - role: pod\n\n  relabel_configs:\n  # Scrape only pods with the annotation: prometheus.io/scrape = true\n  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]\n    action: keep\n    regex: true\n\n  # If prometheus.io/path is specified, scrape this path instead of /metrics\n  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]\n    action: replace\n    target_label: __metrics_path__\n    regex: (.+)\n\n  # If prometheus.io/port is specified, scrape this port instead of the default\n  - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]\n    action: replace\n    regex: ([^:]+)(?::\\d+)?;(\\d+)\n    replacement: $1:$2\n    target_label: __address__\n      \n  # If prometheus.io/scheme is specified, scrape with this scheme instead of http\n  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scheme]\n    action: replace\n    regex: (http|https)\n    target_label: __scheme__\n\n  # Include the pod namespace as a label for each metric\n  - source_labels: [__meta_kubernetes_namespace]\n    action: replace\n    target_label: kubernetes_namespace\n\n  # Include the pod name as a label for each metric\n  - source_labels: [__meta_kubernetes_pod_name]\n    action: replace\n    target_label: kubernetes_pod_name\n  \n  # [Optional] Include all pod labels as labels for each metric\n  - action: labelmap\n    regex: __meta_kubernetes_pod_label_(.+)'
  }
}
