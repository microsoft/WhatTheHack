# Challenge 04: Injecting Chaos into your CI/CD pipeline - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)**

## Notes & Guidance
This challenge may be a larger lift as the students are not required to know GitHub Actions or any other DevOps pipeline tool. We have provided links to the actions needed to complete this task but feel free to nudge more on the GitHub Actions syntax portion as the challenge is more about integrating Chaos into your pipeline and less about the syntax of GitHub Actions.

A sample solution is located [here](./Solutions/Solution-04/Solution-04.yml)

From a high level, it logs into Azure and leverages the AZ Rest command to issue a rest api call to trigger the experiment.  The students could also leverage a standard rest api call, however the AZ rest command is easier to use as it handles many headers for you automatically such as authorization.

[Chaos Studio Rest API Samples](https://learn.microsoft.com/en-us/azure/chaos-studio/chaos-studio-samples-rest-api)
[Starting Experiment with Rest API](https://learn.microsoft.com/en-us/rest/api/chaosstudio/experiments/start?tabs=HTTP)
