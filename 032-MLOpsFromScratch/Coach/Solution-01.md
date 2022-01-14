# Challenge 1 – Run model locally & and import repo into Azure DevOps

[< Previous Challenge](./Solution-00.md) - **[Home](./README.md)** - [Next Challenge >](./Solution-02.md)

## Notes & Guidance

The Coach should zip up the following GitHub [https://github.com/microsoft-us-ocp-ai/DemandForecasting](https://github.com/microsoft-us-ocp-ai/DemandForecasting) as a `Data_and_Code.zip` file and give it to the students via the Teams channel. It contains all the source code files.

## Solution

1.  Create and setup a new project in Azure DevOps
    1.  Download and extract `Data_and_Code.zip` from Teams Channel.
    1.  [Create new service connections](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) in Project Settings for your Azure ML service and Azure Subscription using Azure Resource Manager service principal. This will enable you to connect to external and remote services to execute tasks in a pipeline.     
1.  Clone into VS Code and run the projects files locally to understand the forecasting project and explore the different files available.
1.  Install library requirements to setup your environment inside VS Code Terminal or equivalent Shell application:  
    `pip install -r ./environment_setup/requirements.txt`
1.  Configure your Azure ML Workspace for the project.
    - **HINT:** Add workspace details through Azure DevOps pipeline variables.
    - **HINT:** Add workspace details in config.json. You can download it from portal too.
1.  Now that you have environment setup, explore and run locally the python files in the following order to train an ARIMA forecasting model.
    1.  `Workspace.py` to setup connection with your Azure ML service workspace.
    1.  `AcquireData.py` to get daily transactions data from AdventureWorks.
    1.  `TrainOnLocal.py` to train the model. Explore and run `transactions_arima.py` file to understand how ARIMA model was built.
    1.  `EvaluateModel.py` to evaluate the model.
    1.  `RegisterModel.py` to register the model with Model registry.
    1.  `ScoreModel.py` for scoring/forecasting using the trained model.
    1.  `deployOnAci.py` to deploy the scoring image on ACI.
    1.  `WebserviceTest.py` to the ACI deployment/endpoint.
    