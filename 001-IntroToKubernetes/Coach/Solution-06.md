# Challenge 06 - Deploy MongoDB to AKS - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07.md)

## Notes & Guidance

- The original mongo container image maintained by the mongo project is at:
	- <https://hub.docker.com/_/mongo>
- Bitnami also provides a mongo container image that can be found here:
	- <https://hub.docker.com/r/bitnami/mongodb>
- Encourage students to follow the pattern they used in Challenge 4 and create a deployment and service YAML file for MongoDB and change settings as necessary
- **NOTE:** When creating the service YAML for MongoDB, it is important for students to be aware of the service name they need to use.  
    - The content-init-job.yml file in Challenge 7 sets an environment variable that expects the service to be named “mongodb”.   
    - If the service name does not match, the content-init job will fail with an error.  
    - If students run into this error, help them troubleshoot and come up with a solution, ie: change the service name, or modify the content-init-job.yml file. 