# Table of Contents 

- [Finalize the description for challenge](#Finalize-the-description-for-challenge)
- [Understand required Architecture and Azure components](#Understand-required-Architecture-and-Azure-components) 
- [Get equipped with necessary skills and Knowledge](#Get-equipped-with-necessary-skills-and-Knowledge)
- [Final Architecture](#Final-Architecture)
- [Documentation URLs](#Documentation-URLs)
- [Reference documents](#Reference-documents)


**Description:**

 

Generate self-service sales report from SAP system. Option 1: Extract sales data from SAP system to ADLS and generate analytics  report using power BI /Synapse. Option 2:  Generate self-service sales report using direct query to SAP  HANA system. 

 

# Finalize the description for challenge

    Generate self-service SAP system  report about batch jobs status and  name from SAP system. 

    * Download Power BI client and connect SAP HANA DB using Power BI configuration option. 

   * Extract  table TBTCO ( SAP job status ) using SQL and   Generate self-service Job status report  using direct custom query to SAP system. 

 


# Understand required Architecture and Azure components
 

   * Download Power  BI  desktop from windows power app platfrom  

   * Execute the install and make sure that you have network connectivity from Jump box to SAP HANA DB and required HANA DB ports are open. ( no firewall issues etc..) 

   * For the HANA DB create the SCHEMA user with admin rights on SAP SCHEMA and assign appropriate roles and privileges to extract the data. 

   * Open the BI desktop client and execute the connection configure for SAP HANA database. 

   * Enter the Server IP address , select ports  (custom ) and port  for the  HANA system ID  ( for example SAP HANA system ID NN ports will be 3NN40-3NN99) 

   * Select Appropriate user name,  password and SSL encryption - none 

   * Select direct query for data connectivity Mode  

   * Extract the data and see the  tabular from of the DB 

 

 # Get equipped with necessary skills and Knowledge 

 

   * Target Roles: DBA, BASIS and Technical Architect 

   * SAP HANA database administrator  

   * Report creation and selection for data analytics 

   * HANA DB skills – how to create Schema user and assign roles and privileges 

   * Other tools - perf. benchmark tools, snapshot validation tools, Portal, CLI, bash scripting, Linux Administration 

 

 

 

# Final Architecture 

 
![](media/GetImage.png)
 

# Documentation URLs  

[Use SAP HANA in Power BI - Power BI](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-sap-hana)

[Power Query SAP HANA database connector](https://docs.microsoft.com/en-us/power-query/connectors/sap-hana/overview)


# Reference documents

[Direct Query in Power BI DirectQuery for SAP HANA in Power BI - Power BI](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-directquery-sap-hana)

[Bring your SAP HANA data to life with Microsoft Power BI  Bring your SAP HANA data to life with Microsoft Power BI](https://powerbi.microsoft.com/en-us/blog/bring-your-sap-hana-data-to-life-with-microsoft-power-bi/)

[SAP HANA DB administration Database Administration Tasks at a Glance](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.02/en-US/e77aff8345c640698b69173c034ce094.html)

[SAP Blog on connect Microsoft power BI desktop to HANA Connect Microsoft Power BI Desktop to a HANA System in SCP using SAP Cloud Connector Service Channels](https://blogs.sap.com/2017/01/23/connect-microsoft-power-bi-desktop-to-a-hana-system-in-hcp-using-hana-cloud-connector-service-channels/)





Student introduction 
===================

# Challenge 7: Design a power BI application that connect SAP HANA database using direct query and transform data using power BI desktop client. 



![image](https://user-images.githubusercontent.com/81314847/115069386-7db7b400-9ec1-11eb-8c2a-e018b1e4ceaf.png)




Documentation URL :  
Use SAP HANA in Power BI - Power BI | Microsoft Docs 

https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-sap-hana

Power Query SAP HANA database connector | Microsoft Docs 
https://docs.microsoft.com/en-us/power-query/connectors/sap-hana/overview#:~:text=To%20connect%20to%20an%20SAP%20HANA%20database%20from,your%20credentials%20for%20authentication.%20...%20More%20items...

 

Reference documents: 

 Direct Query in Power  
 https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-directquery-sap-hana

Bring your SAP HANA data to life with Microsoft Power BI  
https://powerbi.microsoft.com/en-us/blog/bring-your-sap-hana-data-to-life-with-microsoft-power-bi/

SAP HANA DB administration
https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.02/en-US/e77aff8345c640698b69173c034ce094.html

SAP Blog on connect Microsoft power BI desktop to HANA 
https://blogs.sap.com/2017/01/23/connect-microsoft-power-bi-desktop-to-a-hana-system-in-hcp-using-hana-cloud-connector-service-channels/ 
