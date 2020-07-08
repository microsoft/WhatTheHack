# Challenge 9: Coach's Guide

[< Previous Challenge](./08-storage.md) - **[Home](README.md)** - [Next Challenge >](./10-networking.md)

## Notes & Guidance
- You should deliver a demo in addition to the lecture to show what a working Helm chart looks like.
- You should provide guidance in the challenge as to which values should be parameterized in the Helm templates.
- **NOTE:** Helm 3 does not create namespaces with yaml files in the chart.
	- The YAML files in the Student Resources folder provides a YAML file that creates a whatthehack namespace. 
	- Students can not include the namespace YAML when creating the helm chart
	- They have to create the namespace by using the **--create-namespace** flag on the helm CLI, eg:
		- `helm install myRelease app-languages --create-namespace whatthehack`
- Consider using the helm chart provided in the Coach Solutions folder for Challenge 9 as one that can be demoed during the lecture.  
- You can also change the challenge to turn the existing YAML files for the FabMedical app they've been working on into a helm chart.  This lets the attendees build on what they have already completed.  The end result should be the same.

