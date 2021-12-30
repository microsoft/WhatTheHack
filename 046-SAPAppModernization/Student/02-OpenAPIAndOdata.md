# Challenge 2: Monitoring for SAP in Azure 

[< Previous Challenge](./01-SAP-Auto-Deployment.md) - **[Home](../README.md)** - [Next Challenge >](./03-SAP-Security.md)

## Introduction

Now that we have an SAP landscape is deployed in Azure it's time to connect it to the outside world. 
In this challenge, you'll configure and connect up an ASP.NET core MVC application to consume OData services from SAP using SAP's demo data set.

## Description

![Odata](Images/Challenge_OData_SAP_Architecture.png)

At this point your SAP data will no longer be an island! There are a number of steps for you to perform.

- Review the following repository and familiarise yourself with it's concepts.
	- [Azure SAP OData Reader](https://github.com/MartinPankraz/AzureSAPODataReader)

- Deploy an empty Developer Tier Azure API Management Instance into your subscription, for this setup you can leave it as not network integrated, but production environments should be located inside a VNet. 
	- Hint: Look in the Azure Portal for "API Management" as a service in the Marketplace.  	

- Configure the API Management instance to connect to your S4 HANA or SAP ECC services as detailed here. 
	- [SAP Configuration] (https://github.com/MartinPankraz/AzureSAPODataReader#azure-api-management-config)
	- Hint, for now use the client side Principal Propagation option, we will enable this in the APIM policy later in another challenge. But let's connect to the data first! 
	
## Success Criteria

- Run an ASP.NET MVC Core app that can view and edit data in SAP HANA via RESTful OData calls, that have been secured and routed via an Azure API Management gateway.

## Learning Resources

- [.net speaks OData too!](https://blogs.sap.com/2021/08/12/.net-speaks-odata-too-how-to-implement-azure-app-service-with-sap-odata-gateway)
- 
- [Azure SAP OData Reader](https://github.com/MartinPankraz/AzureSAPODataReader)


