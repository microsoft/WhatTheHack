# Challenge 7: Analytical Dashboard Using SAP S/4 Hana DB
[< Previous Challenge](./06-Start-Stop-Automation.md) - **[Home](../README.md)** 

# Introduction  

Contoso inc. is a manufacturing company planning to modernize its IT infrastructure. As a part of that efforts, they want to Generate self-service report from SAP HANA DB tables using Microsoft power BI desktop client and develop a self-service report for visualization and analysis. 

 

# Description 
    
  
  This exercise includes connecting power BI desktop client to HANA DB (using direct query with DB user and password), Extract data from the required tables (using semantic SQL query) and Generate self-service Job status report.
  
  A high level architectural diagram can be found below.
  
  
![image](https://user-images.githubusercontent.com/81314847/115074617-eefa6580-9ec7-11eb-9eaa-ca09b29708cb.png)
 


## Tips
 

   * Download and install SAP HANA client for windows from SAP Service Market Place.
    
   * Download [Power BI](https://www.microsoft.com/en-us/download/details.aspx?id=58494) desktop from windows power app platfrom.
    
   * Leverage SAP HANA studio (from Challenge 4) to create the user and required roles and previleges to
     execute the select query to populate the power BI desktop client. 
     
   * For the HANA DB create the SCHEMA user with admin rights on SAP SCHEMA and assign appropriate roles and privileges to extract the data. 
   
   * New user ID in HANA is able to connect to Tenant database where SAP application DATA is residing including the SAP Job log table TBTCO.

     **NOTE:** Below link gives you more details on what is system DB and tenant DB in SAP HANA database.       
    
   
      [SAP HANA Tenant database](https://help.sap.com/viewer/eb3777d5495d46c5b2fa773206bbfb46/2.0.01/en-US/0baadba82dd9407cbb852ae98f49f6bd.html)
   
   * Run the query both in System DB and Tenant DB to indentify the SQL port to connect from Power BI to SAP HANA.

      **NOTE:**  All the details will be found how to query the port both from SYSTEM DB and Tenant DB in SAP HANA from the below link.
      
    

     [Port Assignment in Tenant Databases in SAP HANA Database](https://help.sap.com/viewer/78209c1d3a9b41cd8624338e42a12bf6/2.0.01/en-US/7a9343c9f2a2436faa3cfdb5ca00c052.html)

   * SAP HANA ports will be 3NN40-3NN99, NN is the system number for HANA.

   * Leverage direct query for data connectivity Mode.  

   * Report should have a matrix, a pie chart and a bar chart.
   
   * SAP HANA database has to be up and running when participants try to refresh the data from Power BI desktop.
   

 
## Success Criteria

- Create PowerBI Dashboard displaying data from SAP HANA DB.
- Generate self-service report from SAP HANA DB tables using Microsoft power BI desktop client and develop a
  self-service report for visualization and analysis.
- Publish the visualization from Power BI desktop to power BI Service for broader user community. 
 

## Learning Resources 

* [Use SAP HANA in Power BI - Power BI](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-sap-hana)

* [Power Query SAP HANA database connector](https://docs.microsoft.com/en-us/power-query/connectors/sap-hana/overview)

* [Direct Query in Power BI DirectQuery for SAP HANA in Power BI - Power BI](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-directquery-sap-hana)

* [Bring your SAP HANA data to life with Microsoft Power BI  Bring your SAP HANA data to life with Microsoft Power BI](https://powerbi.microsoft.com/en-us/blog/bring-your-sap-hana-data-to-life-with-microsoft-power-bi/)

* [SAP HANA DB administration Database Administration Tasks at a Glance](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.02/en-US/e77aff8345c640698b69173c034ce094.html)

* [SAP Blog on connect Microsoft power BI desktop to HANA Connect Microsoft Power BI Desktop to a HANA System in SCP using SAP Cloud Connector Service Channels](https://blogs.sap.com/2017/01/23/connect-microsoft-power-bi-desktop-to-a-hana-system-in-hcp-using-hana-cloud-connector-service-channels/)






