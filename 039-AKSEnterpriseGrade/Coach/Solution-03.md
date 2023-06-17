# Challenge 03 - AKS Monitoring - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes and Guidance

* Participants will have to decide when installing Prometheus whether using the Prometheus Operator or installing Prometheus and Grafana manually, both approaches should work.
* This is just an introductory level. Make participants understand the overall structure of each tool (Azure Monitor and Prometheus/Grafana), and some pros/cons of both of them.

## Solution Guide

The script blocks below demonstrate how you can solve this challenge.  They are not the only solutions. 

If the students deployed a private AKS cluster, the way they access and administer it is different than if it is not a private AKS cluster.  Commands will need to be run remotely through a jumpbox. You will observe in the sample solution script blocks below that the commands for private/non-private cluster are encapsulated in if/then/else blocks.

```bash
# Azure Monitor
az aks enable-addons -n $aks_name -g $rg -a monitoring --workspace-resource-id $logws_id
```

If you are using a jump host to a private cluster and egress firewall:

```bash
# Deploy Prometheus/Grafana
remote "helm repo add stable https://charts.helm.sh/stable"
remote "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts"
remote "helm repo update"
remote "helm install prometheus prometheus-community/kube-prometheus-stack"
remote "kubectl patch svc prometheus-grafana -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'"
remote "kubectl patch svc prometheus-grafana -p '{\"metadata\": {\"annotations\": {\"service.beta.kubernetes.io/azure-load-balancer-internal\": \"true\"}}}'"
grafana_admin_password=$(remote "kubectl get secret --namespace default prometheus-grafana -o jsonpath=\"{.data.admin-password}\" | base64 --decode")
sleep 60 # Wait 60 secs until the svc changes from public to private
grafana_ip=$(remote "kubectl get svc/prometheus-grafana -n default -o json | jq -rc '.status.loadBalancer.ingress[0].ip' 2>/dev/null")
# NAT rule
az network firewall nat-rule create -f azfw -g $rg -n nginx \
    --source-addresses '*' --protocols TCP \
    --destination-addresses $azfw_ip --translated-address $grafana_ip \
    --destination-ports 8080 --translated-port 80 \
    -c Grafana --action Dnat --priority 110
echo "You can browse now to http://${azfw_ip}:8080 and use the credentials admin/${grafana_admin_password}"
```

If using a public cluster and no egress firewall:

```bash
# Deploy Prometheus/Grafana
helm repo add stable https://charts.helm.sh/stable
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack
kubectl patch svc prometheus-grafana -p '{"spec": {"type": "LoadBalancer"}}'
grafana_admin_password=$(kubectl get secret --namespace default prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
sleep 60 # Wait 60 secs until the svc changes from public to private
grafana_ip=$(kubectl get svc/prometheus-grafana -n default -o json | jq -rc '.status.loadBalancer.ingress[0].ip' 2>/dev/null)
echo "You can browse now to http://${grafana_ip}:80 and use the credentials admin/${grafana_admin_password}"
```

We will now connect Grafana with Prometheus, and add a dashboard (credits to Mel Cone, more info in her gist [here](https://gist.github.com/melmaliacone/c5d2ef9e390ec3f2d4e510c304fe7bb0)):

1. Add a data source

    a. There should already be an existing data source like `http://prometheus-kube-prometheus-prometheus.default:9090` (check the name of your k8s services on port 9090)

    You can test the data source, the result should be `Data source is working`.

2. Add a Kubernetes Cluster Grafana dashboard

    a. Hover over the plus sign in the panel on the left hand side and click `Import`.

    b. In the `Grafana.com Dashboard` text box enter `7249` and then click `Load` next to the text box. This will import [this Grafana dashboard](https://grafana.com/grafana/dashboards/7249) and take you to a new page titled `Import`.

    > If you have a firewall filtering AKS egress traffic, you need to allow HTTPS to grafana.net.

    c. Under the `Options` section click the `Select a Prometheus data source` and select the data source, which should only have one option.

    Now you should see your dashboard!

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
  endpoint_ip=$nginx_svc_ip
  echo "Using Ingress Controller's IP $nginx_svc_ip as endpoint..."
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

If you are doing this after the service mesh challenge, you might need to uninject the linkerd containers (see [https://github.com/linkerd/linkerd2/issues/2596](https://github.com/linkerd/linkerd2/issues/2596)).

```bash
# Uninject linkerd, re-inject using --proxy-cpu-request/limit:
aks_is_private=$(az aks show -n "$aks_name" -g "$rg" --query apiServerAccessProfile.enablePrivateCluster -o tsv)
# If cluster is private, go over jump host
if [[ "$aks_is_private" == "true" ]]; then
    remote "kubectl get deploy -o yaml | linkerd uninject - | kubectl apply -f -"
    remote "kubectl get deploy -o yaml | linkerd inject --proxy-cpu-request 25m --proxy-cpu-limit 500m  - | kubectl apply -f -"
    remote "kubectl rollout restart deploy/api"
    remote "kubectl rollout restart deploy/web"
else
    kubectl get deploy -o yaml | linkerd uninject - | kubectl apply -f -
    kubectl get deploy -o yaml | linkerd inject --proxy-cpu-request 25m --proxy-cpu-limit 500m  - | kubectl apply -f -
    kubectl rollout restart deploy/api
    kubectl rollout restart deploy/web
fi
```


