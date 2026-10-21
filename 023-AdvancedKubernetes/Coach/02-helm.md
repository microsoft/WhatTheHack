# Challenge 2: Coach's Guide - Helm

[< Previous Challenge](01-setup.md) - **[Home](README.md)** - [Next Challenge >](03-resiliency.md)

## Introduction

Helm is the package manager for Kubernetes.  It was created by Deis (now a part of Microsoft) and is a Graduated Project in the CNCF.

## Key Concepts

- Chart:  A collection of files that describe Kubernetes resources.
- Config: Configuration information that can be merged into a packaged chart
- Release:  A running instance of a chart with a specific config

## Description

In this challenge, you will create and deploy a Helm chart for a sample app, then expose it using the managed application routing add-on with Istio and Kubernetes Gateway API.

### Create a new chart

``` bash
helm create myapp
```

Helm should automatically create the following files and folder structure (depending on version). The solution chart was refreshed using Helm 4.3.0. Recent versions also include an HTTPRoute template, but no Gateway template; add the Gateway manually.

```
myapp
|---charts
|---templates
    |---tests
        |---test-connection.yaml
    |---_helpers.tpl
    |---deployment.yaml
    |---hpa.yaml
    |---httproute.yaml
    |---ingress.yaml
    |---NOTES.txt
    |---service.yaml
    |---serviceaccount.yaml
|---.helmignore
|---Chart.yaml
|---values.yaml
```

### Deploy the chart on your K8S cluster

``` bash
helm install myapp myapp
```

You can see your helm deployment:

``` bash
helm ls
```

### Override default nginx image

To change the container image to the podinfo image, four things will need to be done:

1. Change the container image
2. Change the image tag
3. Change the container port to port 9898 (the port used by the podinfo image)
4. Upgrade the helm deployment

#### Change container image in values.yaml

Modify the values.yaml file:

``` yaml
image:
  repository: stefanprodan/podinfo # change this
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: "" # you can specify image tag here or in Chart.yaml
```

#### Change the image tag

Pick a tag you like from [Docker Hub](https://hub.docker.com/r/stefanprodan/podinfo/tags), for example 4.0.2. The tag will either be the default appVersion in Chart.yaml or the explicit override in values.yaml.

Modify the Chart.yaml file:

``` yaml
appVersion: 4.0.2 # change this
```

#### Change the container port

Add the following to the values.yaml file:

``` yaml
containerPort: 9898 # add this
```

Modify the deployment.yaml file:

``` yaml
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.containerPort }} # change this
              protocol: TCP
```

#### Upgrade the helm deployment

``` bash
helm upgrade myapp myapp
```

### Enable managed application routing with Istio

Follow the [application routing Gateway API guide](https://learn.microsoft.com/en-us/azure/aks/app-routing-gateway-api). Use Azure CLI 2.86.0 or later. This implementation cannot be enabled alongside the Istio service mesh add-on.

Set `$clusterName` and `$group` to the cluster and resource group created in Challenge 1.

``` powershell
az aks update -n $clusterName -g $group --enable-gateway-api --enable-app-routing-istio
kubectl get gatewayclass approuting-istio
```

The GatewayClass should report `Accepted=True`. The controller is managed by AKS, not installed as a separate Helm release.

### Update the chart and add a Gateway and HTTPRoute

Keep the generated Ingress template, but leave `ingress.enabled: false`; using Ingress is discouraged in favor of Gateway API. Add the solution's [Gateway](./Solutions/02-helm/myapp/templates/gateway.yaml) template manually and configure the generated HTTPRoute template (or add the solution's [HTTPRoute](./Solutions/02-helm/myapp/templates/httproute.yaml) template on older Helm versions). Keep both resources and the app Service in the same namespace. Configure these settings in values.yaml:

``` yaml
ingress:
  enabled: false
gateway:
  enabled: true
  className: approuting-istio
httpRoute:
  enabled: true
  parentRefs:
    - name: myapp
      sectionName: http
  hostnames: [] # set after the Gateway receives an external IP
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
```

Upgrade the release, wait for the Gateway, and use its external address to configure the route hostname:

``` powershell
helm upgrade myapp myapp
kubectl wait --for=condition=Programmed gateway/myapp --timeout=180s
$ingressIp = kubectl get gateway myapp -o jsonpath='{.status.addresses[0].value}'
helm upgrade myapp myapp --set "httpRoute.hostnames[0]=myapp.$ingressIp.nip.io"
kubectl get httproute myapp -o yaml
```

Confirm the HTTPRoute reports `Accepted=True` and `ResolvedRefs=True`. It routes `/` to the chart's Service on port 80; the Service forwards to podinfo on port 9898. The solution uses release name `myapp` and the current namespace.

### Verify App is available

``` bash
$ curl "http://myapp.$ingressIp.nip.io"

{
  "hostname": "myapp-5569b97dd-xgf8s",
  "version": "4.0.2",
  "revision": "b4138fdb4dce7b34b6fc46069f70bb295aa8963c",
  "color": "#34577c",
  "logo": "https://raw.githubusercontent.com/stefanprodan/podinfo/gh-pages/cuddle_clap.gif",
  "message": "greetings from podinfo v4.0.2",
  "goos": "linux",
  "goarch": "amd64",
  "runtime": "go1.14.3",
  "num_goroutine": "6",
  "num_cpu": "2"
}
```

### Clean up application routing

Uninstall the app release to remove its Gateway and HTTPRoute, then disable the managed implementation:

``` powershell
helm uninstall myapp
az aks update -n $clusterName -g $group --disable-app-routing-istio
```

## Success Criteria

* `helm ls --all-namespaces` shows your chart (before cleanup)
* Your Gateway is programmed and your HTTPRoute reports `Accepted=True` and `ResolvedRefs=True`
* `curl "http://myapp.$ingressIp.nip.io"` returns HTTP 200 with the podinfo response

## Hints

1. [Helm commands](https://helm.sh/docs/helm/)
1. [Getting started with Helm charts](https://helm.sh/docs/chart_template_guide/getting_started/)
