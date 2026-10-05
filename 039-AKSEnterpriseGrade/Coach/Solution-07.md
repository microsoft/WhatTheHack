# Challenge 07 - Service Mesh - Coach's Guide

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes and Guidance

This guide demonstrates the AKS-managed Istio service mesh add-on, which injects Envoy sidecars into the application pods. Linkerd and self-managed Istio are also valid choices if coaches can verify TLS on both required hops and preserve a functional ingress. The managed add-on is the worked example here, not a requirement for students.

Challenge 2's `approuting-istio` GatewayClass is **ingress-only** and cannot coexist with the mesh add-on. An in-place switch interrupts ingress and may change the private LoadBalancer IP. Save the Gateway/HTTPRoute manifests, TLS Secret, firewall DNAT settings, and recovery plan before switching; changing the GatewayClass or adding sidecars alone is insufficient. See [application routing limitations](https://learn.microsoft.com/azure/aks/app-routing-gateway-api#limitations) and [managed Istio Gateway API](https://learn.microsoft.com/azure/aks/istio-gateway-api).

Examples use Bash (or WSL). Run `az` from an authorized workstation and private-cluster `kubectl` via Challenge 2's `remote` jump-VM helper. Verify the cluster and namespace first. Examples assume `default` contains the web, API, Gateway, and routes; never label a shared namespace with unrelated workloads.

### Other service mesh options

- **Linkerd:** Install and manage Linkerd independently; mesh the web and API workloads **and a compatible ingress controller** so ingress-to-web and web-to-API can both use mTLS. Linkerd does not supply its own ingress controller. Do not assume Challenge 2's `approuting-istio` gateway is enrolled in Linkerd or that a working HTTPS endpoint proves upstream mTLS. Follow the [Linkerd ingress guidance](https://linkerd.io/docs/tasks/using-ingress/) and [mTLS validation guidance](https://linkerd.io/docs/tasks/validating-your-traffic/); replace or reconfigure the ingress if necessary while retaining the private LoadBalancer, TLS Secret, routes, and firewall DNAT behavior used in earlier challenges.
- **Self-managed Istio:** Install and maintain your own Istio control plane, gateway, certificates, and upgrades instead of using the AKS add-on. Reconcile Challenge 2's ingress-only `approuting-istio` GatewayClass with the self-managed ingress; do not assume it becomes part of your mesh. The [Istio via Helm sample](https://github.com/ryanpeters-MSFT/aks-istio-ingress-helm) shows a self-managed Istio installation with Gateway API and sidecars. The [AKS-managed Istio Gateway API sample](https://github.com/ryanpeters-MSFT/aks-istio-gateway-api) illustrates the **managed** alternative, not a self-managed install. Both samples use public ingress and a sample nginx workload; adapt the networking, routes, and TLS configuration for this hack before using them.

For either option, test the page and API after the ingress change and demonstrate authenticated TLS on **gateway-to-web** and **web-to-API**, not only client-to-gateway HTTPS. Avoid running competing Istio controllers for the same GatewayClass.

## AKS-managed Istio add-on with sidecars

### 1. Inventory the existing ingress and plan the cutover

Record the Gateway, routes, address, and security configuration. On the private path, Azure Firewall DNAT targets the Gateway's **private** LoadBalancer IP; revisit it after cutover. Keep Challenge 5's TLS Secret in the Gateway namespace.

```bash
# reuse rg and aks_name from Challenge 2
az aks show -g "$rg" -n "$aks_name" --query '{location:location,mesh:serviceMeshProfile.mode,ingress:ingressProfile.webAppRouting}'
remote "kubectl get gatewayclass; kubectl get gateway,httproute,svc -n default"
remote "kubectl get gateway web-gateway -n default -o yaml"
```

A **separate AKS cluster** with the mesh add-on and Gateway API avoids an in-place outage. Otherwise, schedule a maintenance window and follow the [migration constraints](https://learn.microsoft.com/troubleshoot/azure/azure-kubernetes/extensions/istio-add-on-gateway-api#application-routing-gateway-api-implementation-compatibility-and-migration): disable ingress-only Istio **first**, then enable the mesh in a **separate operation**. Keep managed Gateway API CRDs enabled.

```bash
# only after confirming the cutover plan; this interrupts the existing Gateway
az aks approuting gateway istio disable -g "$rg" -n "$aks_name"
az aks mesh enable -g "$rg" -n "$aks_name"
az aks show -g "$rg" -n "$aks_name" --query serviceMeshProfile
remote "kubectl get pods -n aks-istio-system; kubectl get gatewayclass istio"
```

Check revision compatibility (`az aks mesh get-revisions --location <region> -o table`) against the [mesh install](https://learn.microsoft.com/azure/aks/istio-deploy-addon) and [Gateway API](https://learn.microsoft.com/azure/aks/istio-gateway-api) guides. Skip enablement if the mesh is already installed; **stop** if `approuting-istio` is still enabled.

### 2. Reconcile ingress with the mesh GatewayClass

Copy the [private HTTP Gateway](./Solutions/Challenge-02/gateway-internal.yaml) or [TLS Gateway](./Solutions/Challenge-05/gateway_tls.yaml), change `spec.gatewayClassName` to `istio`, then reapply it and the HTTPRoutes. Preserve the private LoadBalancer `spec.infrastructure.annotations`, listener, hostname, and any Challenge 5 `certificateRefs`; do not create a public LoadBalancer on the private path.

```bash
# after applying the edited Gateway manifest and the existing routes on the jump VM
remote "kubectl get gateway web-gateway -n default -o wide; kubectl get httproute -n default"
remote "kubectl get svc -n default | grep web-gateway"
```

Wait for `Programmed=True`, accepted routes, and a LoadBalancer IP. Update Azure Firewall DNAT to the **new private IP** (or DNS/test URL for a public cluster), then test the page and API path. Retain the TLS Secret for HTTPS. See [managed Istio Gateway API ingress](https://learn.microsoft.com/azure/aks/istio-gateway-api).

### 3. Enroll only the application workloads

Use the add-on's **revision-specific** namespace label, not `istio-injection=enabled`. If `default` contains other workloads, move the app to a dedicated namespace and update routes and Secret references first.

```bash
revision=$(az aks show -g "$rg" -n "$aks_name" --query 'serviceMeshProfile.istio.revisions[0]' -o tsv)
echo "$revision"  # expected: asm-X-Y
remote "kubectl label namespace default istio.io/rev=$revision --overwrite"
remote "kubectl rollout restart deployment/web deployment/api -n default"
remote "kubectl rollout status deployment/web -n default; kubectl rollout status deployment/api -n default"
remote "kubectl get pods -n default -l run=web; kubectl get pods -n default -l run=api"
```

Check that **each** web and API pod has a ready `istio-proxy` (usually `2/2`). If injection fails, check events, namespace label, revision, and resource limits. Sidecars alone do **not** prove encryption.

### 4. Enforce and verify mTLS on both hops

Test the page and API through the programmed `istio` Gateway. Once all callers, including health checks, work, require namespace mTLS with `PeerAuthentication`. `STRICT` blocks unmeshed clients; do not apply it to a shared namespace. External HTTPS does not prove upstream mTLS.

```bash
remote "cat <<'EOF' | kubectl apply -n default -f -
apiVersion: security.istio.io/v1
kind: PeerAuthentication
metadata:
  name: default
spec:
  mtls:
    mode: STRICT
EOF"
remote "kubectl get peerauthentication -n default; kubectl get pods -n default -l run=web; kubectl get pods -n default -l run=api"
```

Retest both routes **after** enforcement. Use [Istio telemetry or proxy logs](https://learn.microsoft.com/azure/aks/istio-telemetry) to show identities and mTLS on gateway-to-web and web-to-API (`connection_security_policy=mutual_tls` if metrics are exported). Verify that an unmeshed test client is rejected, then remove it. Successful requests under `STRICT` demonstrate mTLS only if they traversed the Gateway. Fix broken health checks or integrations before declaring success.

## Coach completion check

- A functional ingress request reaches web and the API, before and after applying mTLS enforcement.
- Evidence distinguishes **client-to-gateway TLS** from **gateway-to-web mTLS** and **web-to-API mTLS**; the latter two must be demonstrated to meet the student success criteria.
- The chosen service mesh is running; web, API, and the ingress controller are enrolled or otherwise configured to provide and verify TLS on both required hops. For the worked example, the AKS-managed Istio add-on is enabled and web and API workloads have ready sidecars.