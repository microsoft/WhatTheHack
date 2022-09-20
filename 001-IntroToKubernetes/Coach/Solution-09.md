# Challenge 09 - Helm - Coach's Guide 

[< Previous Solution](./Solution-08.md) - **[Home](./README.md)** - [Next Solution >](./Solution-10.md)

## Notes & Guidance

- You should deliver a demo in addition to the lecture to show what a working Helm chart looks like.
  - Consider using the `app-languages-helm-chart` helm chart provided in the Coach Solutions folder for Challenge 9 as one that can be demoed during the lecture.  
- You should provide guidance in the challenge as to which values should be parameterized in the Helm templates.
	- At a minimum make sure the version label is parameterized (ie: v1, v2, etc) so that students can install different versions of the app using `helm install` easily.
- **NOTE:** Helm 3 does not automatically create namespaces.
	- The YAML files in the Student Resources folder provides a YAML file that creates a whatthehack namespace.
    	- This should only be used when installing the app manually during the first part of the challenge.
- **NOTE:** When creating their helm charts make sure that students are handling namespaces properly:
	- Students should NOT include the namespace YAML in the helm chart
	- The application's YAML files should NOT include a namespace, we will leave namespace creation up to helm (see below).

## Helm Commands 
First let's install our new chart and make sure it is in the releases as well as check that everything is deployed in Kubernetes
- **NOTE:** Take special note of the `helm install` command and how we are telling it to create a new namespace. Because we did NOT put a namespace in the yaml file templates in our Chart, those resources will go into the namespace we pass into the `-n` parameter, in our case `mynamespace`. We're also using the `--create-namespace` option so that `mynamespace` will be created if it doesn't already exist.

  ```bash
  # install Helm chart
  helm install --create-namespace -n mynamespace --set appData.imageVersion=v2 langfacts-release2 langfacts

  # check that the helm chart shows installed and working
  helm list -A

  # check that all the resources we expect in our new namespace are present
  kubectl get all -n mynamespace
  ```

Next we'll lay out all the commands needed to create the chart using the `app-languages-helm-chart` folder in the Coach Solutions for **Challenge 9** and get it pushed up to your Azure Container Registry
- First of all we need to allow admin access and authenticate ourselves with the ACR and add it as a helm repository on our local system

  ```bash
  # enable admin user on ACR
  az acr update -n myacr -g myrg --admin-enabled true

  # get credentials for Admin user on ACR (save these values)
  az acr credential show -n myacr -g myrg 

  # login Helm to ACR using admin credentials (use values from above for -u and -p)
  export HELM_EXPERIMENTAL_OCI=1
  helm registry login myacr.azurecr.io -u myuser -p mypass

  # Add ACR as Helm Repo and confirm it is in the list
  az acr helm repo add --name myacr
  helm repo list
  ```

- Now we can package up the `app-languages-helm-chart` chart and push it to our ACR helm repo
	- Packaging creates a tarball using the name of our chart provided in `Chart.yaml`
  
  ```bash
  # package Helm chart
  helm package app-languages-helm-chart

  # push Helm Chart to ACR
  az acr helm push -n myacr langfacts-0.1.0.tgz
  ```

- Now let's update our local repo's index and search to see if the `langfacts` chart is available

  ```bash
  # update Helm repo
  helm repo update

  # search for the langfacts chart to make sure it got uploaded
  helm search repo lang
  ```

- Finally let's install our new chart and make sure it is in the releases as well as check that everything is deployed in Kubernetes
  - **NOTE:** Take special note of the `helm install` command and how we are telling it to create a new namespace. Because we did NOT put a namespace in the yaml file templates in our Chart, those resources will go into the namespace we pass into the `-n` parameter, in our case `mynamespace`. We're also using the `--create-namespace` option so that `mynamespace` will be created if it doesn't already exist.

  ```bash
  # install Helm chart
  helm install --create-namespace -n mynamespace --set appData.imageVersion=v2 langfacts-release2 myacr/langfacts

  # check that the helm chart shows installed and working
  helm list -A

  # check that all the resources we expect in our new namespace are present
  kubectl get all -n mynamespace
  ```

## Extra Credit
- You can also change the challenge to turn the existing YAML files for the FabMedical app they've been working on into a helm chart.  This lets the attendees build on what they have already completed.  The end result should be the same.


