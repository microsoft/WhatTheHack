# Challenge 5 - GitOps

[< Previous Challenge](./04-scaling.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](./06-service-mesh.md)

## Introduction

GitOps is a term coined by WeaveWorks for implementing Continuous Delivery for Cloud Native applications.  The core concept is using a Git repository as the source of truth for the desired state of infrastructure.  Flux is the tool written by WeaveWorks to implement GitOps for Kubernetes.

## Description

- Fork [https://github.com/fluxcd/helm-operator-get-started](https://github.com/fluxcd/helm-operator-get-started) in your Github Repo
- Install Flux on your Cluster
    - HINT: Follow the "Install Flux" directions on your cluster
- Follow the instructions for Flux CD pipeline example (just up to the dev deployment)
    - HINT: Remember to update the dev/stg/prod podinfo.yaml file with BOTH your github and dockerhub username
    - HINT: You can use `fluxctl sync` if you're impatient
    - HINT: For automation to start, [the image tag in GitHub must exist in Docker Hub](https://github.com/fluxcd/flux/issues/2929)
- Verify that if you run `ci-mock.sh` you should see a new image deployed in the dev namespace
    - HINT: `kubectl describe pod -n dev | grep Image`
- Using GitOps, add a new namespace called "nginx-ingress"
- Using GitOps, add nginx-ingress and verify with `helm ls --all-namespaces`
    - HINT: nginx-ingress v1.37.0 has been verified to work with no additional values
    - HINT: `INGRESS_IP=$(kubectl get service -n nginx-ingress nginx-ingress-controller -o json | jq '.status.loadBalancer.ingress[0].ip' -r)`
- Using GitOps, expose the dev service at dev.$INGRESS_IP.nip.io
    - HINT: You only need to modify HelmRelease values
- Run `ci-mock.sh` with `-v dev-0.5.0` and curl to verify that new version is deployed

## Success Criteria

- By only changing your GitHub repo, you have done the following
    - Created a new namespace `nginx-ingress`
    - Deployed a new ingress controller
    - Deployed a new version of your application

## Hints

1. [HelmResource](https://docs.fluxcd.io/projects/helm-operator/en/stable/references/helmrelease-custom-resource/)
