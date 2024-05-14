# Challenge 04 - Enable Automated Load Testing (CI/CD) - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance


High level Notes

- There is a sample action which will run a load test.  The default action will either create or run the existing load test.  However, the "TestName" parameter inside the config.yaml file will be automatically lower cased by the GitHub Action.  Since the UI allows upper or lowercase letters, this can cause a duplicate test to be created.
- GitHub will require another action to create issues while ADO has a built-in functionality to do this.
- Students can use the baseline from their first run in challenge 3 to determine what their pass/fail criteria is.

Sample solution JMeter script and configuration is located in the solution directory [here](./Solutions/Challenge4/).