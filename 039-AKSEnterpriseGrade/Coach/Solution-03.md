# Challenge 03 - AKS Monitoring - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes and Guidance

* Recommend **Azure Monitor managed service for Prometheus** and the built-in **Azure Monitor dashboards with Grafana**. Azure Managed Grafana is another managed visualization option; self-hosted Prometheus/Grafana is optional, not the recommended solution. Avoid exposing Grafana with a public LoadBalancer or firewall DNAT just for this challenge.
* Distinguish the three signals: managed Prometheus collects Kubernetes metrics in an **Azure Monitor workspace**; Container Insights collects container logs in a **Log Analytics workspace**; **workspace-based Application Insights** collects web/API request and dependency telemetry. Enabling one does not automatically enable the others.
* Require evidence of Application Insights requests from **both** services. AKS autoinstrumentation for Node.js is public preview; Python is **limited preview** and requires access to that preview. Do not suggest that the Python AKS feature is generally available.

## Solution Guide

These are examples, not the only solutions. Azure CLI cluster operations can run locally; `kubectl` against a private AKS cluster must run from a host with private API access (see [Challenge 2](./Solution-02.md)).

### Managed metrics and container logs

Enable managed Prometheus for cluster metrics and Container Insights for logs. Set `monitorWorkspaceId` to an existing Azure Monitor workspace resource ID and `logws_id` to an existing Log Analytics workspace resource ID; if no Azure Monitor workspace exists, omit its resource-ID argument to use the default. The two workspace types are distinct.

```bash
# use an existing Azure Monitor workspace for Prometheus, or omit the ID to use the default
az aks update -n "$aks_name" -g "$rg" --enable-azure-monitor-metrics --azure-monitor-workspace-resource-id "$monitorWorkspaceId"

# use an existing Log Analytics workspace for Container Insights
az aks enable-addons -n "$aks_name" -g "$rg" -a monitoring --workspace-resource-id "$logws_id"
```

Find cluster, node, and container charts under **AKS > Monitoring > Dashboards with Grafana** in the Azure portal; select a dashboard backed by the Azure Monitor workspace. See [AKS dashboards with Grafana](https://learn.microsoft.com/azure/azure-monitor/visualize/grafana-kubernetes). For logs, open **AKS > Insights > Containers** and inspect the API container logs. Optionally link an [Azure Managed Grafana workspace](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-monitoring-enable) to the Azure Monitor workspace for more dashboards. No in-cluster Prometheus or Grafana Helm release is required.

### Application Insights for web and API

Create a [workspace-based Application Insights resource](https://learn.microsoft.com/azure/azure-monitor/app/create-workspace-resource) and copy its connection string from **Overview**. The web deployment is Node.js and the API deployment is Python/Flask. The [AKS autoinstrumentation guide](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-codeless) supports Node.js without source changes on Linux nodes (public preview); it requires Azure CLI 2.60.0 or later. Enable cluster support:

```bash
az aks update -n "$aks_name" -g "$rg" --enable-azure-monitor-app-monitoring
```

Create an `Instrumentation` custom resource in the **same namespace** as the deployments, pointing to the Application Insights connection string. Use a non-`default` name for per-deployment onboarding, for example:

```yaml
apiVersion: monitor.azure.com/v1
kind: Instrumentation
metadata:
  name: app-insights
  namespace: default
spec:
  settings:
    autoInstrumentationPlatforms: []
  destination:
    applicationInsightsConnectionString: "<APPLICATION_INSIGHTS_CONNECTION_STRING>"
```

Apply this resource from a host that can reach the cluster. In the **pod template** (`spec.template.metadata.annotations`, not top-level Deployment metadata), annotate the web deployment with `instrumentation.opentelemetry.io/inject-nodejs: "app-insights"`. Follow [per-deployment onboarding](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-codeless#per-deployment-onboarding), restart the web deployment if needed, and verify requests in Application Insights.

**Python access gate:** [AKS Python autoinstrumentation](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-codeless-python-net) is a **limited preview** (no SLA; not recommended for production), not the same public-preview onboarding as Node.js. If access is granted, annotate the API pod template with `instrumentation.opentelemetry.io/private-preview-inject-python: "app-insights"`, **not** `inject-python`; namespace-wide Python onboarding is unavailable. Restart the API deployment after onboarding, generate traffic, wait a few minutes, and verify telemetry. These annotations and the custom resource change Kubernetes configuration, not application source code.

If Python preview access is **not** available, do not claim the annotation works. The API still needs Application Insights requests to pass the challenge: use a Python OpenTelemetry instrumentation/export approach supported in your environment, such as packaging the [Azure Monitor OpenTelemetry Python distro](https://learn.microsoft.com/azure/azure-monitor/app/opentelemetry-enable) in a new image and initializing it before Flask imports, or an OpenTelemetry auto-instrumentation deployment with a verified Azure Monitor export path. This may require a container image/startup or application entry-point change; it is **not** a turnkey AKS no-change solution. Coaches should arrange preview access or test and document the alternate API path before running the hack.

Generate requests to the web and `/api/pi` endpoints. In **Application Insights > Logs**, check `AppRequests` for requests from **both** workloads (and `AppDependencies` for web-to-API calls if captured); the **Application Map** can also show the two cloud roles. Check role names so the web and API are distinguishable. Container Insights logs and Prometheus CPU charts alone do **not** satisfy this application telemetry criterion.

### CPU utilization

You can create CPU utilization with these commands, that leverage the `pi` endpoint of the API (calculate pi number with x digits).

```bash
digits=20000  # Test with a couple of digits first (like 10), and then with more (like 20,000) to produce real CPU load
# Determine endpoint IP depending of whether the cluster has outboundtype=uDR or not
aks_outbound=$(az aks show -n aks -g $rg --query networkProfile.outboundType -o tsv)
if [[ "$aks_outbound" == "userDefinedRouting" ]]; then
  endpoint_ip=$azfw_ip
  echo "Using Azure Firewall's IP $azfw_ip as endpoint..."
else
  endpoint_ip=$ingress_svc_ip
  echo "Using managed gateway's IP $ingress_svc_ip as endpoint..."
fi
# Tests
echo "Testing if API is reachable (no stress test yet)..."
curl -k "https://${endpoint_ip}.nip.io/api/healthcheck"
curl -k "https://${endpoint_ip}.nip.io/api/pi?digits=5"
function test_load {
  if [[ -z "$1" ]]
  then
    seconds=60
  else
    seconds=$1
  fi
  echo "Launching stress test: Calculating $digits digits of pi for $seconds seconds..."
  for ((i=1; i <= $seconds; i++))
  do
    curl -s -k "https://${endpoint_ip}.nip.io" >/dev/null 2>&1
    curl -s -k "https://${endpoint_ip}.nip.io/api/pi?digits=${digits}" >/dev/null 2>&1
    sleep 1
  done
}
test_load 120 &
```

You can check the increased CPU utilization in Container Insights, for example:

![](images/azmonitor_cpu.png)

You can deploy an HPA.

```bash
# Create HPA
tmp_file=/tmp/hpa.yaml
file=hpa.yaml
cat > $tmp_file <<EOF
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
EOF
aks_is_private=$(az aks show -n "$aks_name" -g "$rg" --query apiServerAccessProfile.enablePrivateCluster -o tsv)
# If cluster is private, go over jump host
if [[ "$aks_is_private" == "true" ]]; then
  vm_pip_ip=$(az network public-ip show -n "$vm_pip_name" -g "$rg" --query ipAddress -o tsv)
  scp $tmp_file $vm_pip_ip:$file
  ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $vm_pip_ip "kubectl apply -f ./$file"
# If cluster is not private, just deploy the yaml file
else
  kubectl apply -f $tmp_file
fi
```

Check that your deployment has requests and limits:

```bash
# Verify deployment
aks_is_private=$(az aks show -n "$aks_name" -g "$rg" --query apiServerAccessProfile.enablePrivateCluster -o tsv)
# If cluster is private, go over jump host
if [[ "$aks_is_private" == "true" ]]; then
    remote "kubectl get deploy/api -o yaml"
    remote "kubectl describe deploy/api"
else
    kubectl get deploy/api -o yaml
    kubectl describe deploy/api
fi
```

And verify how many API pods exist after generating some load with the bash function `test_load` defined above:

```bash
# Verify deployment
aks_is_private=$(az aks show -n "$aks_name" -g "$rg" --query apiServerAccessProfile.enablePrivateCluster -o tsv)
# If cluster is private, go over jump host
if [[ "$aks_is_private" == "true" ]]; then
    remote "kubectl get hpa"
    remote "kubectl describe hpa/api"
    remote "kubectl top pod"
    remote "kubectl get pod"
else
    kubectl get hpa
    kubectl describe hpa/api
    kubectl top pod
    kubectl get pod
fi
```

If revisiting this challenge after the service mesh exercise, follow the [AKS-managed Istio guidance in Challenge 7](./Solution-07.md). Check that the web and API pods have ready sidecars after changing resource settings; injection is managed by the namespace's mesh revision label, not by manually transforming Deployment manifests.


