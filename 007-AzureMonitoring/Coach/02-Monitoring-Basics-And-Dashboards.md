# Challenge 2: Monitoring Basics and Dashboards

[Previous Challenge](./01-Alerts-Activity-Logs-And-Service-Health.md) - **[Home](../README.md)** - [Next Challenge>](./03-Azure-Monitor-For-Virtual-Machines.md)

## Notes & Guidance

#### Creating an empty database called "tpcc" on the SQL Server

>**Note:** Use SQL Auth with the username being sqladmin and password being whatever you used during deployment

>**Tip:** the "xxxxx" is your unique 5 charaters used during the deployment

- Connect (RDP) to the Visual Studio Server (xxxxxVSSrv) using its public IP address and open Visual Studio.

- Create an account or login with your account

- VS has view called SQL Server Object Explorer that can be used to create and delete SQL databases on the SQL server

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image2.png)

- Connect to the database server VM, make sure to use sqladmin and the password you used during deployment

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image3.png)

- Once connected create a new database called "tpcc"

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image4.png)

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image5.png)
#### Send the SQL DB Active transactions metric to Azure Monitor
  
##### From the portal
  
To find the correct SQL DB counter, go to your Azure Portal, open the VM, then open Run Command as shown in the screen below. 
  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image6.png)    
Run the command - (Get-Counter -ListSet SQLServer:Databases).Paths
  
Once its finished, review the results (scroll up) and copy the output for the 
  
`\SQLServer:Databases(*)\Active Transactions` counter.
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image7.png)  
Now replace the "*" with the target database to be:
`\\SQLServer:Databases(tpcc)\\Active Transactions`
  
Open your VM on the Azure Portal, then go to diagnostic settings and add the counter under performance counters as shown below:
  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/sql_counter.jpg)  
##### From the bicep Template
To do this via code:
- Open the main.bicep file
- Search for this module: `module  sqldiagwindowsvmext  'modules/vmextension/vmextension.bicep' = {`
- Add the SQL counter (shown below) after the Memory commited bytes counter as in the screen below:
```
{
	counterSpecifier: '\\SQLServer:Databases(tpcc)\\Active Transactions'
	sampleRate: 'PT15S'
}
```  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/sql_counter_bicep.jpg)  
- Re-run the bicep deployment and double check your deployment and counters.
  
- Once redeployed, go to metrics and check to make sure you are seeing the new metrics.
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image8.png)  
#### Check your metrics 
  
Now go to the VM Metric, you should see the SQL one we added above, add it and pin it to any of your Dashboards.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image9.png)  
- can you see the new Metric?
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image10.png)
  
>**Tip:** A bunch of OS metrics are configured already under the scale set as a sample.
  
 #### Stress the Database using HammerDB 
- Download and Install HammerDB tool on the Visual Studio VM. 
-  [www.hammerdb.com](http://www.hammerdb.com/)
  
>**Note:** HammerDB does not have native support for Windows Display Scaling. This may result in a smaller than usual UI that is difficult to read over high resolution RDP sessions. If you run into this issue later, close and re-open your RDP session to the VSServer with a lower display resolution. After the RDP session connects, you can zoom into to adjust the size.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image11.png)  
- set it to 125% or more.
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image12.png)
  
- From the Visual Studio Server, download the latest version of HammerDB
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image13.png)  

>**Tip:** If you get this Security Warning, go to Internet Options Security \\ Security Settings \\ Downloads \\ File download \\ Enable.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image14.png)  
- Click enable

  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image15.png)
  
- Click ok, and try again
- If you got the below warning message, click Actions and accept the warnings  

  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image16.png)  
>**Tip:** If you end up closing HammerDB you have to go to C:\\Program Files\\HammerDB-3.1 and run the batch file
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image17.png)
  
- Use HammerDB to create transaction load 
- Double click on SQL Server and click OK, and OK on the confirm popup
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image18.png)   

- Drill into SQL Server \\ TPC-C \\ Schema Build and double click on **Options**
- Modify the Build Options for the following:
	- SQL Server: Name of your SQL Server
	- SQL Server ODBC Driver: SQL Server
	- Authentication: SQL Server Authentication
	- SQL Server User ID: sqladmin
	- SQL Server User Password: \<password  you  used during the deployment\>
	- SQL Server Database: tpcc
	- Number of Warehouses: 50
	- Virtual Users to Build Schema: 50  
>**Note: **Setting the last two at 50 should generate enough load to trip a threshold and run long enough for you to graph to show a spike

  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image19.png)
  
- Double click on Build and Click Yes to kick of a load test.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image20.png)
  
When the test is running it should look like the screenshot below:
>**TIP:** If you would like to run a second test you **must** first delete the database you created and recreate it. HammerDB will not run a test against a database that has data in it. When you run a test is fills the database with a bunch of sample data.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image21.png)  
#### Create your graphs on your dashboard
Remember the metric created above? you can click on pin to my Dashboard then customize it to show the last 1 hour for example (see below)
  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/pin_to_dashboard.jpg)  
- Do this for both the SQL Server Active Transactions and the Percent CPU of the VM ScaleSet
- You may need to customize the dashboard once pinned it to a new Azure Dashboard to reflect the last hour
   

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image22.png)  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image23.png)   
- Dashboard should look something like this
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image24.png)  
#### Create an Alert to be notified in case the SQL active transactions went above 40.
  
- From Azure Monitor, create an Action group, to send email to your address
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image25.png)
    
- Create an Alert if Active Transactions goes over 40 on the SQL Server tpcc database.
    
  ![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image26.png)  
- Make sure to add the correct counter  
    
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image27.png)  

- No set the logic to greater than 40
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image28.png)
  
- Now define the action group to be the one you have created above
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image30.png)
  
- Give the Alert a name, Description and Severity
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image29.png)
  
- If you check your Alert Rules you should see it now enabled.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image31.png)
  
If you re-run the stress test keep in mind, you will need to delete the tpcc DB and re-create it.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image32.png)
  
I assume now you are familier with the whole topic or Dashboards, Alerts ..etc
  
- Create a metric showing the CPU average of your VM scaleset and pin it also to your Dashboard
  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image32_2.png)
   
should looks something like this:
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image33.png)
- Now Create an Alert Rule for CPU over 75% on the Virtual Scale Set that emails you when you go over the threshold.
- Now you need to generate load on your VMSS to do this in the repo you cloned navigate to the folder called **loadscripts** under the **sources** folder and copy the **cpuGenLoadwithPS.ps1** script to both instances running in the Scale Set and run them.

> **Tip:** This may be a bit of a challenge to those not used to working with a scale set. If you just grabed the public IP address and then RDP to it. You will end up on one of the instances but because you are going through the Load Balancer, you cannot control which one. Or can you?
  
If you look at the configuration of the LB in the bicep code, it is configured with an inbound NAT rule that will map starting at port 50000 to each instance in the Scale Set. So if you should RDP using the Public_IP:5000x for instance 1 and PIP:5000y for instance 2.
  
Just to make sure, you can check it in the portal:
  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image33_2.png)  
- Now RDP to each one and Hammer them ;-)
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image34.png)  
- Jump on to both VMs in the Scale Set, Open the PowerShell ISE, Copy the script in the window and run it. You may need to run it more then once to really add the pressure. This script will pin each core on the VM no matter how many you have.
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image35.png)   
Check the CPU load on the VM you are on just to make sure:    

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image35_2.png)  
- You metric should jump as well.    

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image36.png)
>**Note:** The trick to getting the alert to fire is to pin both instances at the same time as the CPU metric is an aggregate of the scale set. If you just max the CPU on one server to 100% the Scale Set is only at 50% and will not trip the alert threshold of 75%. Also, if you run the script and then setup the Alert Rule then go back to run another test to trip the alert.    

Did you noticed? you may have scaled out to a third instance and not realized it.  
You may need to jump on that box and max it out as well.    
 

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image37.png)
You should get an Alert similar to the one below  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image38.png)    
- To suppress the Alerts over the weekends, open your **Action rules** under **Manage actions**

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image45.png)    
- Click on **Action rules**
    
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image46.png)    
- Then click **New Action rule**  
- Under Scope, click on Select a resource and make sure you have your subscription selected. Then search for the name of the resource group that was created in the deployment of the workshop. 
- Select your resource group when it comes up. 
- Click Done    
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image47.png) 
- Filter on the VMs and VMSS
	- Under Filter Criteria, click on filters and select Resource type
	- Equals Virtual Machines and Virtual Machine scales sets    

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image48.png)    
- Under Suppression Config, click on Edit and configure it
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image49.png)  

  
First team to send both alerts wins the challenge!! :)  
Good luck!

## Learning Resources
