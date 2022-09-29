# Challenge 11 - Operations and Monitoring - Coach's Guide 

[< Previous Solution](./Solution-10.md) - **[Home](./README.md)**

## Notes & Guidance

- You can check for the logs of a pod using:
	- `kubectl logs`
- Pod failures can be investigated during troubleshooting with:
	- `kubectl describe pod`
- A bash shell can be opened on any pod so you can poke around on the filesystem to debug issues. You can open the shell with:
	- `kubectl exec -it <pod-name> -- /bin/bash`
- **NOTE:** More coach material needed for Azure Monitor.
	- For now see *Learning Resources* in Student Guide for links.
- **NOTE:** More coach material needed for Kibana.
	- For now see *Learning Resources* in Student Guide for links.
