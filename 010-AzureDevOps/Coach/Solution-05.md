# Challenge 05 - Azure Pipelines: Build and Push Docker Image to Container Registry - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

- This challenge should build upon the last workflow.  We shouldn't be creating a new one as we want to build the code and create the Docker container together.
- As noted in the challenge, we can be more prescriptive on the Docker container concepts and commands since this is an ADO WTH.  However, we should let them get their hands dirty with the pipeline itself.

- Step by step guide
    - Create Service Connection
        - Go to project settings
        - Under "Pipelines" select "Service Connections"
        - Select "New service connection"
        - Select "Docker Registry"
        - Authenticate to your subscription
        - Select the ACR that was created from the previous challenge
        - Add a name for your service connection and save
    - Updating pipeline
        - Go to your CI Build pipeline and edit the YAML file
        - Search for the Docker task via the assistant
        - Select the connection created from the steps above as the "Container registry"
        - Enter the name of your container repository and application.  Example used was `wth/dotnetcoreapp`
        - Add the task to the bottom of the workflow file and run.  If this is the first run you may need to grant permissions which is prompted in the pipeline

