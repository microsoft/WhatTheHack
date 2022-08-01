# Challenge 5: Coach's Guide - Gitops

[< Previous Challenge](./04-scaling.md) - **[Home](README.md)** - [Next Challenge>](./06-service-mesh.md)

Here are the steps to deploy Flux in your AKS cluster.

```bash
kubectl create ns flux
```

```bash
export GHUSER="YOUR_GIITHUB_USERNAME"
```

```bash
fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=git@github.com:${GHUSER}/flux-get-started \
--git-path=namespaces,workloads \
--namespace=flux | kubectl apply -f -
```

```bash
kubectl -n flux rollout status deployment/flux
```

```bash
fluxctl identity --k8s-fwd-ns flux
```

Add deploy key in GitHub with the rsa key from the output above

Add --ui-message='Welcome to Flux' to flux-get-started/workloads/podinfo-dep.yaml

Add ingress rule:

```bash
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: podinfo-ingress
  namespace: demo
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: podinfo
          servicePort: 9898
    host: podinfo.<REPLACE WITH INGESS IP>.nip.io
```

Sync Flux

```bash
fluxctl sync --k8s-fwd-ns flux
```

Go to http://podinfo.$INGRESS_IP.nip.io and see the changes (i.e., welcome to flux)
