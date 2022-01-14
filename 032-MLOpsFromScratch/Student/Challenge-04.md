# Challenge 4 – Create a Release Pipeline In Azure DevOps

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

The `Release` pipeline demonstrates the automation of various stages/tasks involved in deploying an ML model and operationalizing the model in production. The stages generally constitute collecting the Build Artifacts, creating a web service and testing the web service. This web service that gets created in the `Release` Pipeline is a REST endpoint (a Scoring URI) used to predict/forecast on a new dataset. Additionally, it can be plugged into business applications to leverage the intelligence of the model.

There are several ways to create a `Release` pipeline. The two most common and popular ways are: 
-   Using a YAML file that represents the entire pipeline.
-   Using a classic GUI pipeline & adding tasks sequentially.

Use whichever approach your team is most comfortable with.

We can setup Continuous Deployment (CID) trigger for every `Release` pipeline. The pipeline shows how to operationalize the scoring image and promote it safely across different environments.

## Description

- Create a `Release` pipeline.
- Add `Build Artifact` that you created in the [previous challenge](03-BuildPipeline.md).
  - Set Agent Pool to `Azure Pipelines`.
  - Set Agent Specification to `ubuntu-18.04`.
- Add `Release` pipeline tasks:
  - Add a task to setup environment by using `install_environment.sh` file in `environment_setup/` folder. This will install all the python modules required to deploy the forecasting model.
  - Add a task to deploy the scoring image on ACI using `deployOnAci`.py in `service/code/` folder. A “healthy” ACI deployment will be created under Azure ML Endpoints. It contains a REST-based Scoring URI/Endpoint that you can call using Postman or Swagger. 
    - **NOTE:** ACI is recommended to use testing or pre-production stages. Since bigger inferencing compute is needed in production for low latency and high throughput, it is recommended to use AKS cluster in production.
  - Add a task to test the ACI web service using `AciWebserviceTest.py` in `service/code/` folder. This allows you to run the web service on new data (or test data) to forecast demand for new items. 
    - **NOTE:** If the deployment fails or the web service is "unhealthy", check logs in Azure DevOps or Azure ML Studio for issues and additional information.
 
## Success Criteria

- An end-to-end `Release` pipeline in Azure DevOps.
- A “healthy” ACI deployment is created under Azure ML Endpoints, which can be confirmed to be operational by using a tool like [Postman](https://www.postman.com) or [Swagger](https://swagger.io).

## Tips

- Finding the path to where Azure DevOps will copy your build artifact is often the hardest part.
  - You can use the following command in a `Bash` task to print all environment variables (which is how predefined variables are passed to your pipeline).
    ```shell
    env | sort
    ```
  - You can use the following command in a `Bash` task to print a `tree` of the filesystem of your build agent.
    ```shell
    find $(Pipeline.Workspace) -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"
    ```
- Use the [predefined variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/variables?view=azure-devops&tabs=batch) in Azure DevOps to make your tasks simpler & more robust.
- Make sure you specify the version of Python you want the tasks to use (`Python 3.6`, there is a task for this)
- Use the `Azure CLI` task to run the Python scripts since they need to interact with the `Azure Machine Learning` resource.
- If using YAML pipelines, make sure you use the same name that you used for the `Build` pipeline in the `Release` pipeline `pipeline.source`.

## Learning resources

- [Key concepts for new Azure Pipelines users](<https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops>)
- [Release Pipelines general resources](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/?view=azure-devops)
- [MLOps documentation: Model management, deployment, and monitoring with Azure Machine Learning](<https://docs.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment>)
- [MLOps Reference Architecture](<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>)
