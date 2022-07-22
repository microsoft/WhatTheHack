# Challenge 04 - Enable Automated Load Testing (CI/CD) - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance


High level Notes

- There is a sample action which will run a load test.  The default action will either create or run the existing load test.  It is case-sensitive and the GitHub action looks like it lowercase all the tests.
- GitHub will require another action to create issues while ADO has a built-in functionality to do this.
- Students can use the baseline from their first run in challenge 3 to determine what their pass/fail criteria is.

Sample solution JMeter script and configuration is located in the solution directory [here](./Solutions/Challenge4/).