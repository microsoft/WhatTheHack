# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Challenge-00 is all about helping the student set up the prerequisites for this hack. This includes necessary installations, environment options, and other libraries needed. 

They will be creating all needed Azure resources through the Azure AI Foundry. Once they create a hub, they will have an AOAI, AI Search, Azure Document Intelligence, and Azure Storage Account deployed. They will get the credentials for AOAI, AI Search, and Document Intelligence through the AI Foundry. For Azure Storage, they will need to navigate to the Azure Portal.

**NOTE:** Target | Endpoint | Base can be used interchangeably. 

**NOTE:** For all of the challenges, if a student changes any variables in their .env file, they will need to re-run those cells that load the .env file and set the variables in Python. They can check the values of their Jupyter variables by clicking the Jupyter tab in Visual Studio Code. 

### Model Deployment

Challenge 0 has the students deploy multiple models that will be used for the following:
- One model will be used by the Jupyter notebooks for Challenges 1, 3, 4, & 5. The notebooks expect to find the name of this model in the `CHAT_MODEL_NAME` value of the `.env` file.
- A second model will be used in Challenge 2 for model comparison with the Leaderboards in Azure AI Foundry.
- A text embedding model will be used in the Jupyter notebooks for Challenges 3 & 4. The notebooks expect to find the name of this model in the `EMBEDDING_MODEL_NAME` value of the `.env` file.

Students can use different/newer models than the ones listed in the student guide when this hack was published. Most models should work fine. Just ensure the values set in the `.env` file to match the names of the models deployed.

If students use the automation script to deploy the models and populate the `.env` file values, the model names and versions to be deployed are specified in the [`main.bicepparam` file]((../Student/Resources/infra/main.bicepparam)) in the `/infra` folder of the Codespace/DevContainer. These values are listed in a JSON array in the parameter file. The first model in the array will be used to set the value of `CHAT_MODEL_NAME` in the `.env` file for use within the Jupyter Notebooks.
