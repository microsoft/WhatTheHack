# Challenge 06 - Azure Pipelines: Continuous Delivery - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07.md)

## Notes & Guidance
Check inside the predefined variables and update them so the pipelines can be reusable.
See [Use predefined variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml) for more information.

- Recommended to use the deploy app service task in the assistant.  The students can specify the container registry and image they want to deploy from.
- To create the approval gates, students will need to create environments in ADO and assign them to each respective stage.  Stages are required in this challenge while they were a nice to have previously.

- Check the solution file as ADO pipeline solution sample [Solution-06.yaml](./Solutions/Solution-06.yaml)
