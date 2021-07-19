# Challenge 1: Alerts, Activity Logs and Service Health

[Previous Challenge](./00-Getting-Started.md) - **[Home](../README.md)** - [Next Challenge>](./02-Monitoring-Basics-And-Dashboards.md)

## Notes & Guidance

- Login to your portal and stop you Visual Studio VM  

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/stopVM.png)
- Then Start it again
- Now check the Activity Log and see the new events (may take a min or two to show up)

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/vmactivitylog.png)
Now there are two way to create an alert, either from the same screen, click on **Deallocate Virtual Machine** and then click on **New Alert rule**  

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/newalertruleal.png)
  
Or you can go to **Alerts**, and create a **new Alert Rule**, in this case you need to pick your VM as the resource

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/newalertrule.png)

Then you will need to **Add condition**, filter for **Activity log - Administrative** and pick the **Deallocate Virtual Machine**

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/addconditiondeallocate.png)  

  
**The Bonus part (Optional)**

**Will the Alert get fired if the VM was turned off from the OS? or if the VM was not available? why?**
No, as opposed to deallocation, powering off a Microsoft Azure virtual machine (VM) will release the hardware but it will preserve the network resources (internal and public IPs) provisioned for it. Even if the VM`s network components are preserved, once the virtual machine is powered off, the cloud application(s) installed on it will become unavailable. The only scenario in which you should ever choose the stopped state instead of the deallocated state for a VM in Azure is if you are only briefly stopping the server and would like to keep the dynamic IP address for your testing. If that doesn’t perfectly describe your use case, or you don’t have an opinion one way or the other, then you’ll want to deallocate instead so you aren’t being charged for the VM.

First team to a screenshot of the new Alert Rules and New Action Rule wins the challenge!!
Good luck!


## Learning Resources
