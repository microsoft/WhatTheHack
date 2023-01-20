# Web frontend for SQL API

## Usage

Simple PHP web page that can access the [SQL API](../api/README.md). It will show something like this:

![web](web.png)

The container requires these environment variables:

* `API_URL`: URL where the SQL API can be found, for example `http://1.2.3.4:8080` or `http://api:8080`

## Build

 You can build it locally with:

```bash
docker build -t your_dockerhub_user/web:1.0 .
```

or in a registry such as Azure Container Registry with:

```bash
az acr build -r <your_acr_registry> -g <your_azure_resource_group> -t web:1.0 .
```

## Deploy

This web portal requires an existing API to access. Please verify the [API docs](../api/README.md) for details about how to deploy the API before deploying this Web component.

### Run this image locally

Replace the image and the text `your_api_ip_or_hostname` with the relevant values. If you are using a private registry, make sure to provide authentication parameters:

```bash
# Deploy on Docker
docker run -d -p 8081:80 -e "API_URL=http://your_api_ip_or_hostname:8080" --name web fasthacks/sqlweb:1.0
```

### Run this image on an Azure Container Instance

Replace the image and the text `your_api_ip_or_hostname` with the relevant values. If you are using a private registry, make sure to provide authentication parameters:

```bash
# Deploy on ACI
rg=your_resource_group
az container create -n web -g $rg -e "API_URL=http://your_api_ip_or_hostname:8080" --image fasthacks/sqlweb:1.0 --ip-address public --ports 80
```

### Run this image on Kubernetes

You can use the sample manifest to deploy this container, modifying the relevant environment variables and source image:

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: web
  name: web
spec:
  replicas: 1
  selector:
    matchLabels:
      run: web
  template:
    metadata:
      labels:
        run: web
    spec:
      containers:
      - image: fasthacks/sqlweb:1.0
        name: web
        ports:
        - containerPort: 80
          protocol: TCP
        env:
        - name: API_URL
          value: "http://your_api_ip_or_hostname:8080"
      restartPolicy: Always
---
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    run: web
```

### Run this image on Azure App Services

This example Azure CLI code deploys the image on Azure Application Services (aka Web App):

```bash
# Run on Web App
svcplan_name=webappplan
az appservice plan create -n $svcplan_name -g $rg --sku B1 --is-linux
app_name_web=web-$RANDOM
az webapp create -n $app_name_web -g $rg -p $svcplan_name --deployment-container-image-name fasthacks/sqlweb:1.0
az webapp config appsettings set -n $app_name_web -g $rg --settings "API_URL=http://your_api_ip_or_hostname:8080"
az webapp restart -n $app_name_web -g $rg
app_url_web=$(az webapp show -n $app_name_web -g $rg --query defaultHostName -o tsv) && echo $app_url_web
```
