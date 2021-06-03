# Challenge 3: AKS Monitoring - Coach's Guide

[< Previous Challenge](./02-aks_private.md) - **[Home](./README.md)** - [Next Challenge >](./04-aks_secrets.md)

## Notes and Guidance

* Participants will have to decide when installing Prometheus whether using the Prometheus Operator or installing Prometheus and Grafana manually, both approaches should work.
* This is just an introductory level. Make participants understand the overall structure of each tool (Azure Monitor and Prometheus/Grafana), and some pros/cons of both of them.

## Solution Guide

```bash
# Azure Monitor
az aks enable-addons -n $aks_name -g $rg -a monitoring --workspace-resource-id $logws_id
```

```bash
remote "helm install prometheus stable/prometheus"
remote "helm install grafana stable/grafana"
remote "kubectl patch svc grafana -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'"
remote "kubectl patch svc grafana -p '{\"metadata\": {\"annotations\": {\"service.beta.kubernetes.io/azure-load-balancer-internal\": \"true\"}}}'"
grafana_admin_password=$(remote "kubectl get secret --namespace default grafana -o jsonpath=\"{.data.admin-password}\" | base64 --decode")
sleep 60 # Wait 60 secs until the svc chnages from public to private
grafana_ip=$(remote "kubectl get svc/grafana -n default -o json | jq -rc '.status.loadBalancer.ingress[0].ip' 2>/dev/null")
```

```bash
# NAT rule
az network firewall nat-rule create -f azfw -g $rg -n nginx \
    --source-addresses '*' --protocols TCP \
    --destination-addresses $azfw_ip --translated-address $grafana_ip \
    --destination-ports 8080 --translated-port 80 \
    -c Grafana --action Dnat --priority 110
echo "You can browse now to http://${azfw_ip}:8080 and use the password $grafana_admin_password"
```

We will now connect Grafana with Prometheus, and add a dashboard (credits to Mel Cone, more info in her gist [here](https://gist.github.com/melmaliacone/c5d2ef9e390ec3f2d4e510c304fe7bb0)):

1. Add a data source

    a. Once you login you will be taken to the Grafana homepage. Click `Create your first data source`.

    b. This will take you to a page with a list of data sources. Hover over `Prometheus` under the `Time series databases` section and click `Select`.

    c. Under `HTTP` type in the DNS name for your Prometheus Server into the `URL` textbox. The DNS name for you Prometheus server should be something like `http://prometheus-server.default.svc.cluster.local`

    If you've added the correct URL, you should see a green pop-up that says `Data source is working`.

    > Note: If you leave out `http://` or try to use `http://localhost:9090`, you will see a red `HTTP Error Bad Gateway` pop-up.

2. Add a Kubernetes Cluster Grafana dashboard

    a. Hover over the plus sign in the panel on the left hand side and click `Import`.

    b. In the `Grafana.com Dashboard` text box enter `7249` and then click `Load` next to the text box. This will import [this Grafana dashboard](https://grafana.com/grafana/dashboards/7249) and take you to a new page titled `Import`.

    > If you have a firewall filtering AKS egress traffic, you need to allow HTTPS to grafana.net.

    c. Under the `Options` section click the `Select a Prometheus data source` and select the data source, which should only have one option.

    Now you should see your dashboard!

### CPU utilization

You can create CPU utilization with these commands, that leverage the `pi` endpoint of the API (calculate pi number with x digits).

```bash
digits=20000
namespace=test
# Tests
curl -k "https://${namespace}.${azfw_ip}.nip.io/api/healthcheck"
curl -k "https://${namespace}.${azfw_ip}.nip.io/api/pi?digits=5"
function test_load {
  if [[ -z "$1" ]]
  then
    seconds=60
  else
    seconds=$1
  fi
  echo "Calculating $digits digits of pi for $seconds seconds"
  for ((i=1; i <= $seconds; i++))
  do
    curl -s -k "https://${namespace}.${azfw_ip}.nip.io" >/dev/null 2>&1
    curl -s -k "https://${namespace}.${azfw_ip}.nip.io/api/pi?digits=${digits}" >/dev/null 2>&1
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
remote "cat <<EOF | kubectl -n test apply -f -
apiVersion: autoscaling/v2beta2
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
EOF"
```

Check that your deployment has requests and limits:

```bash
# Verify deployment
remote "kubectl -n test get deploy/api -o yaml"
remote "kubectl -n test describe deploy/api"
```

And verify how many API pods exist after generating some load with the bash function `test_load` defined above:

```bash
remote "kubectl -n test get hpa"
remote "kubectl -n test describe hpa/api"
remote "kubectl -n test top pod"
remote "kubectl -n test get pod"
```

If you are doing this after the service mesh lab, you might need to uninject the linkerd containers (see [https://github.com/linkerd/linkerd2/issues/2596](https://github.com/linkerd/linkerd2/issues/2596)).

```bash
# Uninject linkerd, re-inject using --proxy-cpu-request/limit:
remote "kubectl get -n test deploy -o yaml | linkerd uninject - | kubectl apply -f -"
remote "kubectl get -n test deploy -o yaml | linkerd inject --proxy-cpu-request 25m --proxy-cpu-limit 500m  - | kubectl apply -f -"
remote "kubectl rollout restart deploy/api"
remote "kubectl rollout restart deploy/web"
```

