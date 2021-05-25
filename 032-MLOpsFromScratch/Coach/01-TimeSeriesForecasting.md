# Challenge 1 – Start Project and Import Repo into Azure DevOps

[< Previous Challenge](./00-prereqs.md) - **[Home](./README.md)** - [Next Challenge >](./02-BuildPipeline.md)

## Solution

1.  Create and setup a new project in Azure DevOps

    1.  Download and extract `Data_and_Code.zip` from Teams Channel 

    2.  [Create new service connections](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) in Project Settings for your Azure ML service and Azure Subscription using Azure Resource Manager service principal. This will enable you to connect to external and remote services to execute tasks in a pipeline.
        
2.  Clone into VS Code and run the projects files locally to understand the forecasting project and explore the different files available.

3.  Install library requirements to setup your environment inside VS Code Terminal or equivalent Shell application:  
    `pip install -r ./environment_setup/requirements.txt`

3.  Configure your Azure ML Workspace for the project.

    - **HINT:** Add workspace details through Azure DevOps pipeline variables.
    - **HINT:** Add workspace details in config.json. You can download it from portal too.

4.  Now that you have environment setup, explore and run locally the python files in the
    following order to train an ARIMA forecasting model

    1.  `Workspace.py` to setup connection with your Azure ML service workspace.

    2.  `AcquireData.py` to get daily transactions data from AdventureWorks.

    3.  `TrainOnLocal.py` to train the model. Explore and run
        `transactions_arima.py` file to understand how ARIMA model was built.

    4.  `EvaluateModel.py` to evaluate the model.

    5.  `RegisterModel.py` to register the model with Model registry.

    6.  `ScoreModel.py` for scoring/forecasting using the trained model.

    7.  `deployOnAci.py` to deploy the scoring image on ACI.

    8.  `WebserviceTest.py` to the ACI deployment/endpoint.
    
