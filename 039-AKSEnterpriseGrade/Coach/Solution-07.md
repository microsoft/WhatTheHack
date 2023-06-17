# Challenge 07 - Service Mesh - Coach's Guide 

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes and Guidance

* No specific service mesh preferred, linkerd is typically the easiest to start with. If participants want to explore the Microsoft native offering, Open Service Mesh might be better.

## Solution Guide

### Linkerd

Pre-flight check. The warnings on the PSPs (inserted by Grafana in previous labs) are OK and can be safely ignored, since we did not use Pod Security Policies in the lab so far.

```bash
remote "linkerd check --pre"
```

Install Linkerd (note that `gcr.io` needs to be in the list of your allowed prefixes):

```bash
remote "linkerd install | kubectl apply -f -"
remote "kubectl get svc --namespace linkerd --output wide"
remote "kubectl get pod --namespace linkerd --output wide"
remote "linkerd check"
```

Linkerd uses their own version of Grafana, it could be patched and exposed over the Azure Firewall if required, but we are not going to do it here. Plumbing the existing Prometheus/Grafana setup with the linkerd-prometheus svc would be an extra here:

* Adding a new data source in grafana pointing to `http://linkerd-prometheus.linkerd.svc.cluster.local:9090`
* Adding a linkerd dashboard (for example `11868`)

Exposing the linkerd dashboard:

```bash
remote "kubectl -n linkerd patch svc linkerd-web -p '{\"spec\": {\"type\": \"LoadBalancer\"},\"metadata\": {\"annotations\": {\"service.beta.kubernetes.io/azure-load-balancer-internal\": \"true\"}}}'"
remote "kubectl get svc --namespace linkerd --output wide"
linkerd_svc_ip=$(remote "kubectl -n linkerd get svc/linkerd-web -o json | jq -rc '.status.loadBalancer.ingress[0].ip' 2>/dev/null")
while [[ "$linkerd_svc_ip" == "null" ]]
do
    sleep 5
    linkerd_svc_ip=$(remote "kubectl -n linkerd get svc/linkerd-web -o json | jq -rc '.status.loadBalancer.ingress[0].ip' 2>/dev/null")
done
az network firewall nat-rule create -f azfw -g $rg -n linkerd \
    --source-addresses '*' --protocols TCP \
    --destination-addresses $azfw_ip --translated-address $linkerd_svc_ip \
    --destination-ports 8084 --translated-port 8084 \
    -c linkerd --action Dnat --priority 120
echo "You can check the Linkerd dashboard here: http://$azfw_ip:8084"
```

Note the previous does not work, and you would get an error like this:

```
It appears that you are trying to reach this service with a host of '40.74.12.224:8084'. This does not match /^(localhost|127\.0\.0\.1|linkerd-web\.linkerd\.svc\.cluster\.local|linkerd-web\.linkerd\.svc|\[::1\])(:\d+)?$/ and has been denied for security reasons.
Please see https://linkerd.io/dns-rebinding for an explanation of what is happening and how to fix it.
```

You can check for [https://linkerd.io/dns-rebinding](https://linkerd.io/dns-rebinding), or you can just use a Chrome extension such as ModHeader to supply an allowed Host header, such as `localhost`. Note that this might not work everywhere in the portal, and you might get webSocket errors.

### Emojivoto

In order to get familiar with Linkerd, you can play with Linkerd's demo app in this lab, emojivoto:

```bash
# Demo app
remote "curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -"
remote "cat <<EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: emojivoto
  namespace: emojivoto
  annotations:
    kubernetes.io/ingress.class: nginx
    ingress.kubernetes.io/ssl-redirect: \"true\"
spec:
  tls:
  - hosts:
    - emojivoto.$azfw_ip.nip.io
    secretName: tls-secret
  rules:
  - host: emojivoto.$azfw_ip.nip.io
    http:
      paths:
      - path: /
        backend:
          serviceName: web-svc
          servicePort: 80
EOF"
remote "kubectl get -n emojivoto deploy -o yaml | linkerd inject - | kubectl apply -f -"
remote "linkerd -n emojivoto stat deploy"
# remote "linkerd -n emojivoto top deploy"  # You need to run this in a TTY
```

### Ingress controllers

We can inject linkerd in the nginx ingress controller. Make sure to read [Linkerd - Using Ingress](https://linkerd.io/2/tasks/using-ingress/). TL;DR: you need to use the annotation `nginx.ingress.kubernetes.io/configuration-snippet` in your ingress definitions.

```bash
# Inject linkerd in ingress controllers
remote "kubectl get -n nginx deploy -o yaml | linkerd inject - | kubectl apply -f -"
remote "kubectl -n default patch ingress web -p '{\"metadata\": {\"annotations\": {\"nginx.ingress.kubernetes.io/configuration-snippet\": \"proxy_set_header l5d-dst-override \$service_name.\$namespace.svc.cluster.local:\$service_port;\\n\"}}}'"
remote "kubectl -n test patch ingress web -p '{\"metadata\": {\"annotations\": {\"nginx.ingress.kubernetes.io/configuration-snippet\": \"proxy_set_header l5d-dst-override \$service_name.\$namespace.svc.cluster.local:\$service_port;\\n\"}}}'"
remote "kubectl -n nginx rollout restart deploy/nginx-nginx-ingress-controller"
```

### Dedicated namespace

```bash
# Redeploy app in a new namespace
namespace=test
identity_name=apiid
node_rg=$(az aks show -n $aks_name -g $rg --query nodeResourceGroup -o tsv)
identity_id=$(az identity show -g $node_rg -n $identity_name --query id -o tsv)
identity_client_id=$(az identity show -g $node_rg -n $identity_name --query clientId -o tsv)
tmp_file=/tmp/fullapp.yaml
file=fullapp.yaml
cp ./Solutions/$file $tmp_file
sed -i "s|__ingress_class__|nginx|g" $tmp_file
sed -i "s|__ingress_ip__|${azfw_ip}|g" $tmp_file
sed -i "s|__akv_name__|${akv_name}|g" $tmp_file
sed -i "s|__identity_id__|${identity_id}|g" $tmp_file
sed -i "s|__identity_client_id__|${identity_client_id}|g" $tmp_file
sed -i "s|__sql_username__|${sql_username}|g" $tmp_file
sed -i "s|__sql_server_name__|${db_server_name}|g" $tmp_file
sed -i "s|__acr_name__|${acr_name}|g" $tmp_file
sed -i "s|__identity_name__|${identity_name}|g" $tmp_file
sed -i "s|__namespace__|${namespace}|g" $tmp_file
scp $tmp_file $vm_pip_ip:$file
remote "kubectl apply -f ./$file"
remote "kubectl get -n $namespace deploy -o yaml | linkerd inject - | kubectl apply -f -"
echo "You can browse to https://${namespace}.${azfw_ip}.nip.io"
```

```bash
# Test new app deployment
remote "linkerd -n $namespace stat deploy"
```

You should see something like this:

```
NAME   MESHED   SUCCESS      RPS   LATENCY_P50   LATENCY_P95   LATENCY_P99   TCP_CONN
api       1/1   100.00%   0.6rps         100ms       49000ms       49800ms          5
web       1/1   100.00%   0.2rps           0ms           0ms           0ms          1
```

If you send a request from the browser to the web page, and you have the `top` command going, you will see information about the requests

```bash
remote "linkerd -n test top deploy/web"
```

You might have to run the `top` command directly on the Azure VM, instead of over the `remote` alias.

You should see the requests going on in the background: from the ingress controller to the web pods, and from the web pods to the API pods:

```
(press q to quit)
(press a/LeftArrowKey to scroll left, d/RightArrowKey to scroll right)

Source                                           Destination           Method      Path               Count    Best   Worst    Last  Success Rate
web-648d999fd9-5v55l                             api-754f9cd75b-mwt6h  GET         /api/healthcheck       1     5ms     5ms     5ms       100.00%
web-648d999fd9-5v55l                             api-754f9cd75b-mwt6h  GET         /api/sqlversion        1   243ms   243ms   243ms       100.00%
web-648d999fd9-5v55l                             api-754f9cd75b-mwt6h  GET         /api/ip                1   873ms   873ms   873ms       100.00%
nginx-nginx-ingress-controller-6b746b87cf-n67l2  web-648d999fd9-5v55l  GET         /                      1      1s      1s      1s       100.00%
nginx-nginx-ingress-controller-6b746b87cf-n67l2  web-648d999fd9-5v55l  GET         /favicon.ico           1   665µs   665µs   665µs       100.00%
```

If you want more information, you can use the `tap` command:

```bash
jose@vm:~$ linkerd -n test tap deploy/api
req id=2:0 proxy=in  src=10.13.76.71:51450 dst=10.13.76.100:8080 tls=not_provided_by_remote :method=GET :authority=10.13.76.100:8080 :path=/api/healthcheck
rsp id=2:0 proxy=in  src=10.13.76.71:51450 dst=10.13.76.100:8080 tls=not_provided_by_remote :status=200 latency=2197µs
end id=2:0 proxy=in  src=10.13.76.71:51450 dst=10.13.76.100:8080 tls=not_provided_by_remote duration=21µs response-length=21B
req id=2:1 proxy=in  src=10.13.76.71:51690 dst=10.13.76.100:8080 tls=not_provided_by_remote :method=GET :authority=10.13.76.100:8080 :path=/api/healthcheck
rsp id=2:1 proxy=in  src=10.13.76.71:51690 dst=10.13.76.100:8080 tls=not_provided_by_remote :status=200 latency=2034µs
end id=2:1 proxy=in  src=10.13.76.71:51690 dst=10.13.76.100:8080 tls=not_provided_by_remote duration=25µs response-length=21B
req id=2:2 proxy=in  src=10.13.76.95:51800 dst=10.13.76.100:8080 tls=true :method=GET :authority=test.40.74.12.224.nip.io :path=/api/ip
rsp id=2:2 proxy=in  src=10.13.76.95:51800 dst=10.13.76.100:8080 tls=true :status=200 latency=245728µs
end id=2:2 proxy=in  src=10.13.76.95:51800 dst=10.13.76.100:8080 tls=true duration=50µs response-length=464B
req id=2:3 proxy=in  src=10.13.76.71:51942 dst=10.13.76.100:8080 tls=not_provided_by_remote :method=GET :authority=10.13.76.100:8080 :path=/api/healthcheck
rsp id=2:3 proxy=in  src=10.13.76.71:51942 dst=10.13.76.100:8080 tls=not_provided_by_remote :status=200 latency=2005µs
end id=2:3 proxy=in  src=10.13.76.71:51942 dst=10.13.76.100:8080 tls=not_provided_by_remote duration=41µs response-length=21B
req id=2:4 proxy=in  src=10.13.76.95:51800 dst=10.13.76.100:8080 tls=true :method=GET :authority=test.40.74.12.224.nip.io :path=/api/pi
rsp id=2:4 proxy=in  src=10.13.76.95:51800 dst=10.13.76.100:8080 tls=true :status=200 latency=2620µs
end id=2:4 proxy=in  src=10.13.76.95:51800 dst=10.13.76.100:8080 tls=true duration=34µs response-length=28B
```

### Alternative: use existing pods in the default namespace

If participants have deployed their app in default, they might encounter some problems. Here follow some instructions for update an existing web/api deployment in the default namespace. First we need to convert our services in ClusterIP (this might not be required):

```bash
# Change services to ClusterIP
remote "kubectl delete svc/api"
remote "kubectl delete svc/web"
remote "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  type: ClusterIP
  ports:
  - port: 8080
    targetPort: 8080
  selector:
    run: api
---
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 80
  selector:
    run: web
EOF"
```

```bash
# Inject linkerd
remote "kubectl get deploy/web -o yaml | linkerd inject --enable-debug-sidecar - | kubectl apply -f -"
remote "kubectl get deploy/api -o yaml | linkerd inject --enable-debug-sidecar - | kubectl apply -f -"
remote "kubectl rollout restart deploy/api"
remote "kubectl rollout restart deploy/web"
```

If you needed to uninject the containers you can do it with the linkerd CLI as well:

```bash
# Uninject linkerd
remote "kubectl get deploy/api -o yaml | linkerd uninject - | kubectl apply -f -"
remote "kubectl rollout restart deploy/api"
remote "kubectl get deploy/web -o yaml | linkerd uninject - | kubectl apply -f -"
remote "kubectl rollout restart deploy/web"
```

**NOTE**: for HPA to keep working, you would need to use the `--proxy-cpu-request` and `--proxy-cpu-limit` flags, but we will ignore it for the moment. See the Monitoring challenge for more details.

Have a look at the pods to see the linkerd containers running:

```bash
# Inspect pods
api_pod_name=$(remote "kubectl get pods -l run=api -o custom-columns=:metadata.name" | awk NF)
remote "kubectl get pod $api_pod_name -o yaml"
remote "kubectl describe pod $api_pod_name"
web_pod_name=$(remote "kubectl get pods -l run=web -o custom-columns=:metadata.name" | awk NF)
remote "kubectl get pod $web_pod_name -o yaml"
remote "kubectl describe pod $web_pod_name"
```

You can generate some traffic with a modified `test_load` bash function (see the Monitoring challenge):

```bash
digits=10000
function test_load2 {
  if [[ -z "$1" ]]
  then
    seconds=60
  else
    seconds=$1
  fi
  echo "Sending test traffic for $seconds seconds"
  for ((i=1; i <= $seconds; i++))
  do
    curl -s -k "https://${azfw_ip}.nip.io" >/dev/null 2>/dev/null
    sleep 1
    curl -s -k "https://${azfw_ip}.nip.io/api/healthcheck" >/dev/null 2>/dev/null
    sleep 1
    curl -s -k "https://${azfw_ip}.nip.io/api/pi?digits=${digits}" >/dev/null 2>/dev/null
  done
}
test_load2 300
```

We can verify that Linkerd sees the traffic.

