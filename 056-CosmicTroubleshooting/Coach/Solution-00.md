# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

- Please refer prerequisites as listed under student section [Pre-reqs.](../Student/00-prereqs.md)
- Please make sure that the Students have the deployment files within the archive you will provide (should have `Challenge00` and `Challenge02` folders, please do not provide `Challenge02` as that is a coach's reference implementation).
- In a test environment we tried out the deployment, `dotnet build` would not execute for the web application to get packaged and deployed due to an empty nuget source list (the build face will error out as it will be unable to restore the required packages). If this happens, please see [nuget add source examples](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-nuget-add-source#examples)
- Should the students choose to re-deploy, they can but they might face an issue with the load test script deployment. As Azure Load Testing is in Preview at the time of writing, there is an issue with the test plan validation on updating an existing Test plan. They should disregard the Timeout error that will get generated.
- If the students opt for the Bash script, they might get an error with `/bin/bash^M: bad interpreter: No such file or directory`. Ask them to run the following command: `sed -i -e 's/\r$//' <script name>.sh`