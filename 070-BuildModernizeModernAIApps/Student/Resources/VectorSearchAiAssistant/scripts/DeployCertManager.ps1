#! /usr/bin/pwsh

# Adds the official cert-manager repository to your local and updates the repo cache
Invoke-Expression "helm repo add jetstack https://charts.jetstack.io"
Invoke-Expression "helm repo update"

# Installs cert-manager on cluster
Invoke-Expression "helm upgrade --install cert-manager jetstack/cert-manager --namespace kube-system --version v1.9.1 --set installCRDs=true"