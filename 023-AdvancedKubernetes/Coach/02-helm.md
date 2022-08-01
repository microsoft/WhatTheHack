# Challenge 2: Coach's Guide - Helm

[< Previous Challenge](01-setup.md) - **[Home](README.md)** - [Next Challenge >](03-resiliency.md)

## Introduction

Helm is the package manager for Kubernetes.  It was created by Deis (now a part of Microsoft) and is a Graduated Project in the CNCF.

## Key Concepts

- Chart:  A collection of files that describe Kubernetes resources.
- Config: Configuration information that can be merged into a packaged chart
- Release:  A running instance of a chart with a specific config

## Description

In this challenge, you will create a new chart, deploy it and then also deploy an existing chart from a remote repository.  These charts will setup an Ingress Controller as well as a sample app.

### Create a new chart

``` bash
helm create myapp
```

Helm should automatically create the following files and folder structure:

```
myapp
|---charts
|---templates
    |---tests
        |---test-connection.yaml
    |---_helpers.tpl
    |---deployment.yaml
    |---hpa.yaml
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

### Install NGINX Ingress Controller using Helm

Follow the instructions [here](https://docs.microsoft.com/en-us/azure/aks/ingress-basic):

``` bash
# Create a namespace for your ingress resources
kubectl create namespace ingress-basic

# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
```

You can see all of your helm deployments:

``` bash
helm ls --all-namespaces
```

### Update the chart and add Ingress route

Get the ingress ip:

``` bash
INGRESS_IP=$(kubectl get service -n ingress-basic nginx-ingress-ingress-nginx-controller -o json |
 jq '.status.loadBalancer.ingress[0].ip' -r)
echo $INGRESS_IP
```

Enable ingress in values.yaml, setting hostname to refer to the ingress ip:

``` yaml
ingress:
  enabled: true # change this
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  hosts:
    - host: myapp.52.141.219.8.nip.io # change to your ingress ip
      paths: ["/"] # change this
```

Upgrade the Helm deployment

``` bash
helm upgrade myapp myapp
```

### Verify App is available

``` bash
$ curl myapp.$INGRESS_IP.nip.io

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

### Uninstall the ingress controller from your cluster

``` bash
helm uninstall nginx-ingress --namespace nginx-ingress
```

## Success Criteria

* `helm ls --all-namespaces` shows your chart and the Ingress controller
* `curl myapp.$INGRESS_IP.nip.io` returns a valid reponse

## Hints

1. [Helm commands](https://helm.sh/docs/helm/)
1. [Getting started with Helm charts](https://helm.sh/docs/chart_template_guide/getting_started/)
