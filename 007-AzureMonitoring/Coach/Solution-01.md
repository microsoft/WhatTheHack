# Challenge 01 - Monitoring Basics: Metrics, Logs, Alerts and Dashboards - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

>**Note** Azure Monitor Agent (AMA) replaces several legacy monitoring agents, like the Log Analytics Agent (Microsoft Monitoring Agent, MMA, OMS), Diagnostics agent and Telegraf agent. The legacy Log Analytics agent will not be supported after August 2024. For this reason, we will be using **only the Azure Monitor Agent (AMA)** in this Hackathon. We won't be using any of the legacy agents.

### Create an empty database called `tpcc` on the SQL Server

Some students may struggle with this particular task if they do not have previous experience with SQL Server. If that is the case, please make sure you guide them on how to create an empty database (as the key goal of the challenge is to learn Azure Monitor, not SQL Server).

>**Note** Use SQL Authentication with the username being `sqladmin` and password being whatever you used during deployment

>**Note** The `XX` in each resource name will vary based on the Azure region the eShopOnWeb Azure environment has been deployed to.

You can use SQL Management Studio on either the SQL Server VM or the Visual Studio VM, or SQL Server Object Explorer view in Visual Studio to create the database. Below you can find the steps for the SQL Server Object Explorer.

- Use Azure Bastion to connect to the Visual Studio Server VM (`vmwthvsdXX`) and open Visual Studio.

- Visual Studio has a view called SQL Server Object Explorer that can be used to create and delete SQL databases on the SQL server.

![SQL Server Object Explorer](../Images/01-00-SQL-view.png)

- Connect to the database server VM (`vmwthvsdXX`), make sure to use SQL Server Authentication with username `sqladmin` and the password you set during deployment.

![Connect to the database server VM in SQL Server Object Explorer](../Images/01-01-Connect-to-db.png)

- Once connected create a new database called `tpcc`

![Creating a new database in SQL Server Object Explorer](../Images/01-02-Add-db.png)

![New database created](../Images/01-03-View-db.png)



### Send the SQL Server VM performance counters to Azure Monitor

>**Note** This task may be quite challenging for some students. Provide hints early on if you notice that the students are getting stuck.
  
To find the correct name of the SQL DB counter, go to your Azure Portal, open the VM, then open Run Command as shown in the screen below. 
  
![Running a PowerShell script in Azure Portal](../Images/01-05-Run-cmdlet.png)

Run the command - ```PowerShell(Get-Counter -ListSet SQLServer:Databases).Paths```
  
Once its finished, review the results (scroll up) and copy the output for the 
  
`\SQLServer:Databases(*)\Active Transactions` counter.
  
![Command output](../Images/01-06-CommandOutput.png)

Now replace the "*" with the target database to be:
`\SQLServer:Databases(tpcc)\Active Transactions`

If you navigate to the Metrics blade for both VMs, you should only be able to see Virtual Machine host metrics. To add guest-level monitoring, create a Data Collection Rule. 
- On the Monitor menu, select Data Collection Rules.
- Select Create to create a new data collection rule and associations.

![A list of Data collection rules in Azure Portal](../Images/01-13-Create-DCR.png)

- Enter a Rule name and specify a Subscription, Resource Group, Region, and Platform Type (Windows):

![Creating a Data collection rule in Azure Portal](../Images/01-14-Create-DCR.png)

- On the Resources tab select + Add resources and associate SQL Server VM to the data collection rule.
- On the Collect and deliver tab, select Add data source to add a data source and set a destination.
- Select Data source type "Performance Counters" and then select "Basic". Make sure that all Performance Counters are selected.

![Adding Basic performance counters to a Data collection rule in Azure Portal](../Images/01-15-Create-DCR.png)

- On the Destination tab, add Azure Monitor Metrics and Azure Monitor Logs (select existing Log Analytics workspace).

![Adding data destinations to a Data collection rule in Azure Portal](../Images/01-16-Create-DCR.png)

- Select Add data source.
- Click on the newly created Data Source called Performance Counters to open it.
- Select Custom, add the SQL DB performance counter (`\SQLServer:Databases(tpcc)\Active Transactions`) to the list, make sure it is selected by the tick and click Save.

![Adding Custom performance counters to a Data collection rule in Azure Portal](../Images/01-17-Create-DCR.png)

- Select Review + create to review the details of the data collection rule and association with the set of virtual machines.
- Select Create to create the data collection rule.



### Check your metrics 
  
Now go to the VM Metric, you should see the SQL one we added above, add it and pin it to any of your Dashboards (It may take several minutes for the guest metrics to start flowing into the Azure Metrics store).
    
![VM Guest metrics now displayed along with Host metrics in Azure Portal](../Images/01-08-ChartFilter01.png) 

Can you see the new Metric?
    
![Selecting the custom SQL Server metric](../Images/01-09-ChartFilter02.png)

### Pin charts to your dashboard

You can click on Pin to dashboard, then customize it to show the last 1 hour (see below)
  
![Pinning metrics charts to a dashboard](../Images/01-22-PinToDashboard.jpg)

Do this for both the SQL Server Active Transactions and the Percent CPU of the VM Scale Set

- SQL Server Active Transactions
 
![Azure dashboard with pinned metrics chart displaying the custom SQL Server metric](../Images/01-23-CustomizeTileData.png)  

![Configuring dashboard tile settings](../Images/01-24-ConfigureTileData.png) 
 
- VM Scale Set Percentage CPU
  
![Creating a chart for Percentage CPU metric of the Virtual Machine Scale Set](../Images/01-25-PinVMSSPercentageCPU.png)

In the end after you run all the stress tests the dashboards, should look like this:

![View of the properly configured Azure Dashboard](../Images/01-04-Sample-dashboard.png)



### Send the SQL Server VM Event Logs to Azure Monitor

Follow the same steps that you used previously to create another data collection rule. The only difference will be on the Add data source step:
- Instead of selecting Performance Counters, select Windows Event Logs and choose basic System and Application logs (Critical, Error, Warning, Informational)

![Adding Basic event logs to a Data collection rule in Azure Portal](../Images/01-18-Create-DCR.png)

- On the Destination tab the only available option will be Azure Monitor Logs (select existing Log Analytics workspace).



### Create an Alert rule to be notified in case the SQL active transactions went above 40.
  
- From Azure Monitor, create an Action group to send email to your address
  
![Creating an Action group in Azure Portal](../Images/01-26-CreateActionGroup.png)

- Create an Alert if Active Transactions goes over 40 on the SQL Server `tpcc` database.
    
![Creating an Alert rule in Azure Portal](../Images/01-27-CreateAlertRule.png) 
  
- Make sure to add the correct counter  
    
![Selecting a performance counter while creating an alert rule](../Images/01-28-AddCorrectCounter.png)

- Now set the logic to greater than 40
  
![Setting a threshold while creating an alert rule](../Images/01-29-ConfigureSignalLogic.png)

- Now define the action group to be the one you have created above

![Selecting an action group while creating an alert rule](../Images/01-30-DefineActionGroup.png)
  
- Give the Alert a Name, Description and Severity

![Configuring an Alert rule](../Images/01-31-AlertRuleDetails.png)
  
- If you check your Alert Rules you should see it now enabled.
  
![A list of Alert rules in Azure Portal](../Images/01-32-AlertRulesEnabled.png)
  
- Similarly create an Alert Rule for CPU over 75% on the Virtual Scale Set that emails you when you go over the threshold.

### Create an Alert processing rule to suppress the alerts over the weekends

- To suppress the Alerts over the weekends, in Azure Monitor under Alerts open your **Alert processing rules**

![Finding Alert processing rules in Azure Portal](../Images/01-19-Create-Alert-proc-rule.png)

- Click Create
- Under Scope, click on Select a resource and make sure you have your subscription selected. Then search for the name of the resource group that was created in the deployment of the workshop. 
- Select your resource group when it comes up. 
- Click Apply      
- Under Filter, select Resource type under Filters, Equals under Operator, and select "Virtual Machines" and "Virtual Machine scales sets" under Value    

![Configuring filters for an Alert processing rule](../Images/01-20-Create-Alert-proc-rule.png) 

- Go to Rule settings and select Suppress Notifications.
- Go to Scheduling, select Recurring, Weekly, Sat & Sun, All day.

![Configuring a schedule for an Alert processing rule](../Images/01-21-Create-Alert-proc-rule.png) 

- On the Details tab select a Subscription, resource group and type the name of the new rule.
- Click Review and Create and then Create.



 ### Stress the Database using HammerDB 
 
- Download and Install HammerDB tool on the Visual Studio VM. 
-  [www.hammerdb.com](http://www.hammerdb.com/)
  
>**Note:** HammerDB does not have native support for Windows Display Scaling. This may result in a smaller than usual UI that is difficult to read over high resolution RDP sessions. If you run into this issue later, close and re-open your RDP session to the VS Server with a lower display resolution. After the RDP session connects, you can zoom into to adjust the size.

![Remote Desktop Connection settings](../Images/01-10-RemoteDesktopConnection.png)

- set it to 125% or more.

![Remote Desktop Connection scaling settings](../Images/01-11-RemoteDesktopConnectionSettings.png)

- From the Visual Studio Server, download the latest version of HammerDB  

![HammerDB web site](../Images/02-01-HammerDB.png)  

>**Tip:** If you get this Security Warning, go to Internet Options Security \\ Security Settings \\ Downloads \\ File download \\ Enable.  

![Security warning “Your current security settings do not allow this file to be downloaded](../Images/01-33-SecurityAlertDialog.png)

- Click enable
  
![Enable Downloads in the browser Security Settings](../Images/01-34-EnableBrowserDownloads.png)

- Click ok, and try again
- If you got the below warning message, click Actions and accept the warnings  
  
![Warning “HammerDB .exe is not commonly downloaded and could harm your computer”](../Images/01-35-HammerDBWarning.png)

>**Tip:** If you end up closing HammerDB you have to go to C:\\Program Files\\HammerDB-3.1 and run the batch file
  
![HammerDB.exe in File Explorer](../Images/01-36-HammerDBInExplorer.png)

- Use HammerDB to create transaction load 
- Double click on SQL Server and click OK, and OK on the confirm popup

![Setting up HammerDB](../Images/02-02-HammerDB.png)  

- Drill into SQL Server \\ TPC-C \\ Schema Build and double click on **Options**
- Modify the Build Options for the following:
	- SQL Server: Name of your SQL Server
	- Encrypt Connection: No
	- SQL Server ODBC Driver: SQL Server
	- Authentication: SQL Server Authentication
	- SQL Server User ID: `sqladmin`
	- SQL Server User Password: \<password  you  used during the deployment\>
	- SQL Server Database: `tpcc`
	- Number of Warehouses: 50
	- Virtual Users to Build Schema: 50  
>**Note: **Setting the last two at 50 should generate enough load to trip a threshold and run long enough for you to graph to show a spike
  
![Configuring a Build in HammerDB](../Images/01-12-HammerDB-settings.png)
  
- Double click on Build. Click Yes to kick off a load test.

![Starting the build](../Images/02-04-HammerDB.png)
  
When the test is running it should look like the screenshot below:
>**TIP:** If you would like to run a second test you **must** first delete the database you created and recreate it. HammerDB will not run a test against a database that has data in it. When you run a test it fills the database with a bunch of sample data.
 
![Monitoring the build run](../Images/02-05-HammerDB.png) 

- In a few minutes you should get an alert similar to this one.

![Email alert received](../Images/01-37-AlertEmail.png)

If you re-run the stress test, keep in mind you will need to delete the `tpcc` DB and re-create it.

### Generate load on the Virtual Machine Scale Set

Now you need to generate load on your VMSS. To do this, in the repo you cloned navigate to the `Student/Resources/Challenge-01` folder and copy the **`cpuGenLoadwithPS.ps1`** script to both instances running in the Scale Set and run them.

> **Tip:** This may be a bit of a challenge to those not used to working with a scale set. If you just grabbed the public IP address and then RDP to it. You will end up on one of the instances but because you are going through the Load Balancer, you cannot control which one. Or can you?
  
If you look at the configuration of the LB in the bicep code, it is configured with an inbound NAT rule that will map starting at port 50000 to each instance in the Scale Set. So if you should RDP using the Public_IP:5000x for instance 1 and PIP:5000y for instance 2.
  
Just to make sure, you can check it in the portal:
   
![Load Balancer Inbound NAT rules in Azure Portal](../Images/01-38-VMSSInboundNatRule.png)

- Now RDP to each one and Hammer them ;-)
  
![RDP Dialog window](../Images/01-39-RemoteToVMSSInstance.png)

- Jump on to both VMs in the Scale Set, Open the PowerShell ISE, Copy the script in the window and run it. You may need to run it more than once to really add the pressure. This script will pin each core on the VM no matter how many you have.

![PowerShell script in Windows PowerShell ISE](../Images/01-40-RunScriptInPowerShellISE.png)

Check the CPU load on the VM you are on just to make sure:    

![Viewing CPU Performance in Windows Task Manager](../Images/01-41-TaskManagerCPU100.png) 

- You metric should jump as well.    

![Viewing Percentage CPU metric in Azure Portal](../Images/01-42-VMSSMetricView.png)

>**Note:** The trick to getting the alert to fire is to pin both instances at the same time as the CPU metric is an aggregate of the scale set. If you just max the CPU on one server to 100% the Scale Set is only at 50% and will not trip the alert threshold of 75%. Also, if you run the script and then setup the Alert Rule then go back to run another test to trip the alert.    

Did you notice? You may have scaled out to a third instance and not realized it.  
You may need to jump on that box and max it out as well.    

![Checking Virtual Machine Scale Set scaling out in Azure Portal](../Images/01-43-VMSSInstances.png)

You should get an Alert similar to the one below  

![Email alert received](../Images/01-44-AlertEmailVMSS.png)

First team to send both alerts wins the challenge!! :)  
Good luck!

