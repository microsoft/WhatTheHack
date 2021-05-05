# Challenge 7: Analytical Dashboard Using SAP S/4 Hana DB
[< Previous Challenge](./06-Start-Stop-Automation.md) - **[Home](../README.md)** 

# Introduction  

Mango Inc is a manufacturing company planning to modernize IT infrastructure. As a part of that efforts, they want to Generate self-service report from SAP HANA DB tables using Microsoft power BI desktop clients and apps for visualization and analysis purpose. This exercise includes connecting power BI desktop client to HANA DB using direct query with DB user and password, Extract the required tables using semantic SQL query and Generate self-service Job status report using direct custom query to SAP system. 

 

# Description 

        
    ## Generate self-service SAP system  report about batch jobs status and  name from SAP system. 
    
  
   * Download Power BI client and connect SAP HANA DB using Power BI configuration option
   * Extract  table TBTCO ( SAP job status ) using SQL and   Generate self-service Job status report  using direct custom query to SAP system. 

![image](https://user-images.githubusercontent.com/81314847/115074617-eefa6580-9ec7-11eb-9eaa-ca09b29708cb.png)
 


## Tips
 

   * Download Power  BI  desktop from windows power app platfrom  

   * Execute the install and make sure that you have network connectivity from Jump box to SAP HANA DB and required HANA DB ports are open. ( no firewall issues etc..) 

   * For the HANA DB create the SCHEMA user with admin rights on SAP SCHEMA and assign appropriate roles and privileges to extract the data. 

   * Open the BI desktop client and execute the connection configure for SAP HANA database. 

   * Enter the Server IP address , select ports  (custom ) and port  for the  HANA system ID  ( for example SAP HANA system ID NN ports will be 3NN40-3NN99) 

   * Select Appropriate user name,  password and SSL encryption - none 

   * Select direct query for data connectivity Mode  

   * Extract the data and see the  tabular from of the DB 

 


 

 



## Learning Resources 

[Use SAP HANA in Power BI - Power BI](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-sap-hana)

[Power Query SAP HANA database connector](https://docs.microsoft.com/en-us/power-query/connectors/sap-hana/overview)

[Direct Query in Power BI DirectQuery for SAP HANA in Power BI - Power BI](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-directquery-sap-hana)

[Bring your SAP HANA data to life with Microsoft Power BI  Bring your SAP HANA data to life with Microsoft Power BI](https://powerbi.microsoft.com/en-us/blog/bring-your-sap-hana-data-to-life-with-microsoft-power-bi/)

[SAP HANA DB administration Database Administration Tasks at a Glance](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.02/en-US/e77aff8345c640698b69173c034ce094.html)

[SAP Blog on connect Microsoft power BI desktop to HANA Connect Microsoft Power BI Desktop to a HANA System in SCP using SAP Cloud Connector Service Channels](https://blogs.sap.com/2017/01/23/connect-microsoft-power-bi-desktop-to-a-hana-system-in-hcp-using-hana-cloud-connector-service-channels/)






