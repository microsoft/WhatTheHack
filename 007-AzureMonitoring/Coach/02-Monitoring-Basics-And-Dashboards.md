# Challenge 2: Monitoring Basics and Dashboards

[Previous Challenge](./01-Alerts-Activity-Logs-And-Service-Health.md) - **[Home](../README.md)** - [Next Challenge>](./03-Azure-Monitor-For-Virtual-Machines.md)

## Notes & Guidance

- Enable the collection of the following counter:
	- \SQLServer:Databases(*)\Active Transactions
- Stress the "tpcc" DB using HammerDB. For detailed instructions, see section [HammerDB Configuration]() below.
- Simulate a CPU load on the VM Scale Set using the [cpuGenLoadwithPS.ps1](https://github.com/msghaleb/AzureMonitorHackathon/blob/master/sources/Loadscripts/cpuGenLoadwithPS.ps1)
- Pin the metric of the above SQL counter as well as the average VMSS CPU utilization to your Dashboard
- Create an Alert to be notified in case the SQL active transactions went above 40
- Create an Alert to get notified if the average CPU load on the VMSS is above 75%
- Suppress the Alerts over the weekends

#### HammerDB Configuration

##### Stress the Database using HammerDB 
- From the Visual Studio Server, download and install the latest version of [HammerDB](http://www.hammerdb.com/)
  ![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image13.png)    
- Open HammerDB and double click on SQL Server to start configuring the transaction load. In the dialog that opens, click OK.
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
	- 
>**Note: **Setting the last two at 50 should generate enough load to trip a threshold and run long enough for you to graph to show a spike

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image19.png)
  
- Double click on Build and Click Yes to kick of a load test.
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image20.png)
  
When the test is running it should look like the screenshot below:
>**TIP:** If you would like to run a second test you **must** first delete the database you created and recreate it. HammerDB will not run a test against a database that has data in it. When you run a test is fills the database with a bunch of sample data.

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image21.png) 

## Learning Resources
