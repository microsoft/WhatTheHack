# Challenge 6: Coach's Guide

[< Previous Challenge](./05-scaling.md) - **[Home](README.md)** - [Next Challenge >](./07-updaterollback.md)

## Notes & Guidance

- The original mongo container image maintained by the mongo project is at:
	- <https://hub.docker.com/_/mongo>
- Encourage students to follow the pattern they used in Challenge 4 and create a stateful set and service YAML file for MongoDB and change settings as necessary
- Given that within this challenge, MongoDB is deployed without any persistent storage, the use of a Stateful Set (rather than just using a Deployment) could be seen as overkill.  However, the need for the stateful set will become more apparent when we get to Challenge 8 and we refactor MongoDb to use persistent volumes.
- **NOTE:** When creating the service YAML for MongoDB, it is important for students to be aware of the service name they need to use.  
    - The content-init-job.yml file in Challenge 7 sets an environment variable that expects the service to be named “mongodb”.   
    - If the service name does not match, the content-init job will fail with an error.  
    - If students run into this error, help them troubleshoot and come up with a solution, ie: change the service name, or modify the content-init-job.yml file. 

