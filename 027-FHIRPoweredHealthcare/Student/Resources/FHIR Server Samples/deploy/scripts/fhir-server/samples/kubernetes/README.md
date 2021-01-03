# Running Microsoft FHIR Server for Azure in Kubernetes

The Microsoft FHIR Server for Azure can be deployed in a Kubernetes cluster. This document describes how to deploy and configure [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) to be able to run the FHIR server in it. Specifically, it describes how to install [Azure Service Operator](https://github.com/Azure/azure-service-operator) in the cluster to allow easy deployment of managed databases (Azure SQL or Cosmos DB). The repo contains a [helm](https://helm.sh) chart that leverages the Azure Service Operator to deploy and configure both FHIR service and backend database. 

## Deploy and configure AKS cluster

In order to provision the FHIR server in AKS, you need the following:

1. [AKS cluster](https://docs.microsoft.com/azure/aks/kubernetes-walkthrough)
1. [Azure Service Operator](https://github.com/Azure/azure-service-operator)
1. [Cert Manager](https://cert-manager.io/)
1. [NGINX ingress controller](https://kubernetes.github.io/ingress-nginx/)

You can use the [deploy-aks.sh](deploy-aks.sh) script included in this repo:

```bash
./deploy-aks.sh --name <my-environment> --resource-group-name <my-rg-name> --location westus2
```

If you prefer to install the components manually, use the script as a guide for the installation steps.

## Deploying the FHIR service to AKS

Once AKS has been deployed and configured, deploy the FHIR server with:

```bash
helm install my-fhir-release helm/fhir-server/ \
  --set database.resourceGroup="my-database-resource-group" \
  --set database.location="westus2"
```

You will need to supply a resource group and location for the database. The AKS cluster service principal must have privileges (Contributor rights) to create database resources in this resource group. The service principal will have contributor permissions on the resource group where the cluster is deployed, but you can also create a different group as long as you grant the service principal permissions. If you have provisioned your cluster with the `deploy-aks.sh` script (see above), the service principal id can be found in a keyvault in the AKS resource group.

The default settings will deploy the FHIR server with a cluster IP address, which is not accessible from the outside, but you can map a local port to the FHIR service with:

```bash
kubectl port-forward service/my-fhir-release-fhir-server 8080:80
```

And the access the FHIR server with:

```bash
curl -s http://localhost:8080/Patient | jq .
```

If you would like the FHIR service to have a public IP address, you can use a LoadBalancer service:

```bash
helm install my-fhir-release helm/fhir-server/ \
  --set database.resourceGroup="my-database-resource-group" \
  --set database.location="westus2" \
  --set service.type=LoadBalancer
```

and locate the public IP address with:

```bash
kubectl get svc my-fhir-release-fhir-server
```

## Configuring FHIR server with ingress controller

The cluster deployment script adds an nginx ingress controller to cluster. Use the ingress controller for directing traffic to specific FHIR instances and for SSL termination. The ingress controller needs an SSL certificate. You have two options:

1. Supply an existing certificate in a secret.
1. Use cert-manager (also installed in the cluster) to get the certificate from an issuer like [Let's Encrypt](https://letsencrypt.org/).


### Use existing certificate

To use an existing certificate with the FHIR server, first create a kubernetes secret to hold the certificate:

```bash
kubectl create secret tls my-example-tls --key server.key --cert cert.pem
```

You are now ready to create the FHIR server using the certificate. We will use an `ingress-values.yaml` file to hold the ingress settings:

We have to set a few values, so to make that easier, create an `ingress-values.yaml` file:

```yaml
ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
    hosts:
      - host: mytestfhir.example.com
        paths:
            - /
    tls:
      - secretName: my-example-tls
        hosts:
          - mytestfhir.example.com
```

Then deploy the FHIR server with:

```bash
helm install myfhirserverrelease helm/fhir-server/ \
  -f ingress-values.yaml \
  --set database.dataStore="SqlServer" \
  --set database.location="westus2" \
  --set database.resourceGroup="mydatabaseresourcegroup"
```

## Use Let's Encrypt

You can add an `Issuer` or `ClusterIssuer` resource to the cluster, which will take care of interacting with Let's Encrypt. Create a manifest (e.g. `letsencrypt-issuer.yaml`) for a `ClusterIssuer`:

```yaml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: YOUR-EMAIL-ADDRESS
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - http01:
        ingress:
          class: nginx
```

Add your own email address. Let's Encrypt will use that to send you emails regarding expiring certificates, etc. Then add the issuer to the cluster

```bash
kubectl apply -f letsencrypt-issuer.yaml
```

If you want the issuer to only apply to a specific namespace, use `Issuer` instead.

Next make sure that you have an A record pointing to the public IP address of the ingress controller. You can find this public IP address with:

```bash
kubectl get svc -n ingress-controller
```

To test if your cert-manager is working correctly with Let's Encrypt, you can create a certificate with a manifest like:

```yaml
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: mytest-mydomainname
spec:
  dnsNames:
    - mytest.example.com
  secretName: mytest-example-tls
  issuerRef:
    kind: ClusterIssuer
    name: letsencrypt
```

If you add that to a file called `cert.yaml` you can then add it to the cluster with:

```bash
kubectl apply -f cert.yaml
```

You can check with `kubectl get certificates` if your cert is ready. If the cert is not available within a few seconds, check `kubectl get certificaterequests` and use `kubectl describe certificaterequest <request name>` to investigate any problems.

If your certificate deploys succcessfully you are ready to deploy a FHIR service with ingress controller. We have to set a few values, so to make that easier, create an `ingress-values.yaml` file:

```yaml
ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt
    hosts:
      - host: mytestfhir.example.com
        paths:
            - /
    tls:
      - secretName: mytestfhir-tls
        hosts:
          - mytestfhir.example.com
```

Then deploy the FHIR server with:

```bash
helm install myfhirserverrelease helm/fhir-server/ \
  -f ingress-values.yaml \
  --set database.dataStore="SqlServer" \
  --set database.location="westus2" \
  --set database.resourceGroup="mydatabaseresourcegroup"
```

## Configuring CORS

The ingress controller can also be used to manage CORS settings, to enable CORS add the appropriate annotations, e.g. building on the `ingress-values.yaml` file from above:

```yaml
ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt
      nginx.ingress.kubernetes.io/enable-cors: "true"
      nginx.ingress.kubernetes.io/cors-allow-origin: "*"
      nginx.ingress.kubernetes.io/cors-allow-methods: "*"
      nginx.ingress.kubernetes.io/cors-allow-headers: "*"
      nginx.ingress.kubernetes.io/cors-max-age: "1440"
    hosts:
      - host: mytestfhir.example.com
        paths:
            - /
    tls:
      - secretName: mytestfhir-tls
        hosts:
          - mytestfhir.example.com
```

## Prometheus Metrics

The FHIR service can (optionally) expose [Prometheus](https://prometheus.io) metrics on a seperate port. In order to collect (scrape) the metrics, will need to install Prometheus in your cluster. This can be done with the [Prometheus Operator](https://github.com/coreos/prometheus-operator).

You can enable this Prometheus metrics with the `serviceMonitor.enabled` parameter by adding a `serviceMonitor` section to your values:

```yaml
serviceMonitor:
  enabled: true
  labels:
    prometheus: monitor
```

The `label` has to match the `serviceMonitorSelector.matchLabels` for your `Prometheus` resource. You can find the match labels with:

```bash
kubectl get -n <prometheus namespace> Prometheus -o json | jq .items[0].spec.serviceMonitorSelector
```

which should have something like:

```json
{
  "matchLabels": {
    "prometheus": "monitor"
  }
}
```

to work with the settings above.

## Enabling `$export`

To use the `$export` operation, the FHIR server must be configured with a [pod identity](https://github.com/Azure/aad-pod-identity) and the identity of the FHIR server must have access to an existing storage account.

1. Ensure that AAD Pod Identity is deployed in your cluster. The [deploy-aks.sh](deploy-aks.sh) script does that. You can verify it with:

    ```bash
    kubectl get pods | grep aad-pod-identity
    ```

    you should see pods with names like `aad-pod-identity-mic-XXXXX` and `aad-pod-identity-nmi-YYYYY`.

2. Create an identity in a resource group where the AKS cluster has access:

    ```bash
    # Some settings
    RESOURCE_GROUP=$(kubectl get nodes -o json | jq -r '.items[0].metadata.labels."kubernetes.azure.com/cluster"')
    LOCATION=$(kubectl get nodes -o json | jq -r '.items[0].metadata.labels."topology.kubernetes.io/region"')
    SUBSCRIPTION_ID=$(az account show | jq -r .id)
    IDENTITY_NAME="myfhirserveridentity"

    # Create identity
    az identity create -g $RESOURCE_GROUP -n $IDENTITY_NAME --subscription $SUBSCRIPTION_ID
    IDENTITY_CLIENT_ID="$(az identity show -g $RESOURCE_GROUP -n $IDENTITY_NAME --subscription $SUBSCRIPTION_ID --query clientId -otsv)"
    IDENTITY_RESOURCE_ID="$(az identity show -g $RESOURCE_GROUP -n $IDENTITY_NAME --subscription $SUBSCRIPTION_ID --query id -otsv)"
    ```

3. Create a storage account and assign role to identity:

    ```bash
    STORAGE_ACCOUNT_NAME="myfhirstorage"
    az storage account create -g $RESOURCE_GROUP -n $STORAGE_ACCOUNT_NAME
    STORAGE_ACCOUNT_ID=$(az storage account show -g $RESOURCE_GROUP -n $STORAGE_ACCOUNT_NAME | jq -r .id)
    BLOB_URI=$(az storage account show -g $RESOURCE_GROUP -n $STORAGE_ACCOUNT_NAME | jq -r .primaryEndpoints.blob)
    az role assignment create --role "Storage Blob Data Contributor" --assignee $IDENTITY_CLIENT_ID --scope $STORAGE_ACCOUNT_ID
    ```      

4. Provision FHIR server:

    First create a `fhir-server-export-values.yaml` file:

    ```bash
    cat > fhir-server-export-values.yaml <<EOF
    database:
      dataStore: SqlServer
      resourceGroup: $RESOURCE_GROUP
      location: $LOCATION
    podIdentity:
      enabled: true
      identityClientId: $IDENTITY_CLIENT_ID
      identityResourceId: $IDENTITY_RESOURCE_ID
    export:
      enabled: true
      blobStorageUri: $BLOB_URI
    EOF
    ```

    Add additional settings you might need (see ingress, CORS, etc. above) and then deploy with:

    ```bash
    helm upgrade --install mihansenfhir2 helm/fhir-server -f fhir-server-export-values.yaml
    ```
