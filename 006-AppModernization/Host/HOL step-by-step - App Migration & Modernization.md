Application migration and modernization

Hands-on lab step-by-step

March 2019

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2018 Microsoft Corporation. All rights reserved.

Microsoft and the trademarks listed at <https://www.microsoft.com/en-us/legal/intellectualproperty/Trademarks/Usage/General.aspx> are trademarks of the Microsoft group of companies. All other trademarks are property of their respective owners.

**Contents**

<!-- TOC -->

- [Application migration and modernization hands-on lab step-by-step](#application-migration-and-modernization-hands-on-lab-step-by-step)
  - [Abstract and learning objectives](#abstract-and-learning-objectives)
  - [Overview](#overview)
  - [Requirements](#requirements)
  - [Before the hands-on lab](#before-the-hands-on-lab)
    - [Task 1: Set up the environment](#task-1-set-up-the-environment)
    - [Task 2: Validate you can connect to the Development Environment](#task-2-validate-you-can-connect-to-the-development-environment)
  - [Exercise 1: Migration to Azure PaaS](#exercise-1-migration-to-azure-paas)
    - [Task 1: Migrate the Website to Azure PaaS](#task-1-migrate-the-website-to-azure-paas)
    - [Task 2: Setup Traffic Manager (Optional)](#task-2-setup-traffic-manager-optional)
    - [Task 3: Migrate the Data to SQL Azure](#task-3-migrate-the-data-to-sql-azure)
    - [Task 4: Finalize Migration](#task-4-finalize-migration)
  - [Exercise 2: Implementing DevOps Continuous Integration / Continuous Deployment (CI/CD)](#exercise-2-implementing-devops-continuous-integration--continuous-deployment-cicd)
    - [Task 1: Add a new project to Azure DevOps and upload the code](#task-1-add-a-new-project-to-azure-devops-and-upload-the-code)
    - [Task 2: Upload Code to Git Repository in Azure DevOps](#task-2-upload-code-to-git-repository-in-azure-devops)
    - [Task 3: Use App Service Deployment Center to create CI/CD](#task-3-use-app-service-deployment-center-to-create-cicd)
    - [Task 3 (Alternative): Use Azure DevOps to create CI/CD](#task-3-alternative-use-azure-devops-to-create-cicd)
  - [Exercise 3: Detect, Diagnose, Monitor Application Performance with Application Insights](#exercise-3-detect-diagnose-monitor-application-performance-with-application-insights)
    - [Task 1: Create an Application Insights Instance](#task-1-create-an-application-insights-instance)
    - [Task 2: Update your Web Application to use Application Insights](#task-2-update-your-web-application-to-use-application-insights)
    - [Task 3: Update your application to provide client side telemetry](#task-3-update-your-application-to-provide-client-side-telemetry)
    - [Task 4: Implement the Custom Event Telemetry Provider](#task-4-implement-the-custom-event-telemetry-provider)
    - [Task 5: Push your code to production](#task-5-push-your-code-to-production)
    - [Task 5: Review the data](#task-5-review-the-data)
  - [Exercise 4: Optimize and Protect Azure Web Application](#exercise-4-optimize-and-protect-azure-web-application)
    - [Task 1: Configure Backups](#task-1-configure-backups)
    - [Task 2: Configure Storage Account for Backups](#task-2-configure-storage-account-for-backups)
    - [Task 3: Schedule Backup](#task-3-schedule-backup)
    - [Task 4: Backup Database](#task-4-backup-database)
    - [Task 5: Viewing Health by Reviewing the Response Time and Errors](#task-5-viewing-health-by-reviewing-the-response-time-and-errors)
    - [Task 6: Setting Alerts](#task-6-setting-alerts)
    - [Task 7: Configuration App Diagnostics](#task-7-configuration-app-diagnostics)
    - [Task 8: Viewing Application CPU/Memory](#task-8-viewing-application-cpumemory)
    - [Task 9: Viewing Disk space](#task-9-viewing-disk-space)
    - [Task 10: Configuring Auto Scale Up](#task-10-configuring-auto-scale-up)
    - [Task 11: Enable App Service Auto Scale Out](#task-11-enable-app-service-auto-scale-out)
    - [Task 12: Prepare for scaling in another region](#task-12-prepare-for-scaling-in-another-region)
    - [Task 13: Viewing Resource Health and History](#task-13-viewing-resource-health-and-history)
    - [Task 14: View Auto Scale Run History](#task-14-view-auto-scale-run-history)
    - [Task 15: Setting up auto scaling notifications](#task-15-setting-up-auto-scaling-notifications)
  - [Exercise 5: Optimize and Secure Azure SQL Database](#exercise-5-optimize-and-secure-azure-sql-database)
    - [Task 1: Resource Locking](#task-1-resource-locking)
    - [Task 2: Enable Transparent Data Encryption](#task-2-enable-transparent-data-encryption)
    - [Task 3: Scale Up Database Performance](#task-3-scale-up-database-performance)
    - [Task 4: Configure Firewall and virtual networks](#task-4-configure-firewall-and-virtual-networks)
    - [Task 5: Threat Detection and Vulnerability Assessment](#task-5-threat-detection-and-vulnerability-assessment)
    - [Task 6: Turn on SQL Server Auditing](#task-6-turn-on-sql-server-auditing)
    - [Task 7: Automatic Tuning](#task-7-automatic-tuning)
    - [Task 8: Enable Database Diagnostics](#task-8-enable-database-diagnostics)
    - [Task 9: Configure Long-term backup retention for database](#task-9-configure-long-term-backup-retention-for-database)
  - [Exercise 6: Optimize Entire Web Application Performance with Content Distributed Network (CDN)](#exercise-6-optimize-entire-web-application-performance-with-content-distributed-network-cdn)
    - [Task 1: Configure CDN for the whole web application](#task-1-configure-cdn-for-the-whole-web-application)
    - [Task 2: Configure Caching Rules](#task-2-configure-caching-rules)
    - [Task 3: Improve performance by adding compression](#task-3-improve-performance-by-adding-compression)
  - [Exercise 7: Optimize Partial Web Application Performance with Content Distributed Network (CDN)](#exercise-7-optimize-partial-web-application-performance-with-content-distributed-network-cdn)
    - [Task 1: Create a Resource Group & Storage Account](#task-1-create-a-resource-group--storage-account)
    - [Task 2: Provision](#task-2-provision)
    - [Task 3: Add a CDN Endpoint](#task-3-add-a-cdn-endpoint)
    - [Task 4: Copy images to storage account](#task-4-copy-images-to-storage-account)
    - [Task 5: Integrate into web application](#task-5-integrate-into-web-application)
    - [Task 6: Explore Enhancements](#task-6-explore-enhancements)
  - [Exercise 8: Increase Application / Database Performance with Redis Cache](#exercise-8-increase-application--database-performance-with-redis-cache)
    - [Task 1: Provisioning the Redis Cache Service](#task-1-provisioning-the-redis-cache-service)
    - [Task 2: Improve Session Performance](#task-2-improve-session-performance)
    - [Task 4: Speed Up Output and Reduce Memory Footprint](#task-4-speed-up-output-and-reduce-memory-footprint)
    - [Task 5: Reducing database utilization](#task-5-reducing-database-utilization)
  - [Exercise 9: Improve Quality & Performance of Search with Azure Search](#exercise-9-improve-quality--performance-of-search-with-azure-search)
    - [Task 1: Create Azure Search Service](#task-1-create-azure-search-service)
    - [Task 2: Import Data in Azure Search](#task-2-import-data-in-azure-search)
    - [Task 3: Integrate search into application](#task-3-integrate-search-into-application)
    - [Task 4: Verify Search Results](#task-4-verify-search-results)
    - [Task 5: Commit & Sync Code](#task-5-commit--sync-code)
  - [Exercise 10: Accelerate development and take advantage of serverless using Azure Functions](#exercise-10-accelerate-development-and-take-advantage-of-serverless-using-azure-functions)
    - [Task 1: Refactor](#task-1-refactor)
    - [Task 2: Modernize](#task-2-modernize)
    - [Task 3: Integrate](#task-3-integrate)
    - [Task 4: Publish the Service](#task-4-publish-the-service)
    - [Task 5: Configure Function Database Connection](#task-5-configure-function-database-connection)
    - [Task 5: Configure Function Application Insights](#task-5-configure-function-application-insights)
    - [Task 6: Modify App Service CI/CD Task](#task-6-modify-app-service-cicd-task)
  - [Exercise 11: Monetize your data and services, and open new channels to customers using Azure API Management](#exercise-11-monetize-your-data-and-services-and-open-new-channels-to-customers-using-azure-api-management)
    - [Task 1: Create Azure API Management](#task-1-create-azure-api-management)
    - [Task 2: Set up new a new API in the Azure Portal](#task-2-set-up-new-a-new-api-in-the-azure-portal)
    - [Task 3: Enable Application Insights](#task-3-enable-application-insights)
    - [Task 4: Explore the API Management (APIM) Developer Portal](#task-4-explore-the-api-management-apim-developer-portal)
  - [After the hands-on workshop](#after-the-hands-on-workshop)

<!-- /TOC -->

# Application migration and modernization hands-on lab step-by-step

## Abstract and learning objectives

Migrate and modernize legacy on-premises applications and infrastructure by
leveraging several cloud services, while adding a mix of modern services.

Learning Objectives:

- Use Azure App Services
- Implement Continuous Integration & Delivery with Azure DevOps
- Detect, Diagnose, Monitor Application Performance with Application Insights
- Optimize & Protect Azure Web Application
- Optimize & Secure Azure SQL Database
- Optimize Entire Web Application Performance with Content Distributed Network (CDN)
- Optimize Partial Web Application Performance with Content Distributed Network (CDN)
- Increase Application / Database Performance with Redis Cache
- Use Search to make content full text searchable
- Accelerate development and take advantage of serverless using Azure Functions
- Monetize your data and services, and open new channels to customers using Azure API Management

## Overview

The App Modernization hands-on lab is an exercise that will challenge you to implement an end-to-end migration and modernization scenario using a supplied sample that is based on Microsoft Azure App Services and related services. The scenario will include implementing compute, storage, security, and search, using various components of Microsoft Azure. The hands-on lab can be implemented on your own, but it is highly recommended to pair up with other members at the lab to model a real-world experience and to allow each member to  share their expertise for the overall solution.

## Requirements

1. Microsoft Azure subscription (non-Microsoft subscription)
2. **Global Administrator role** for Azure AD within your subscription
3. Local machine with Remote Desktop installed

## Before the hands-on lab

**Duration**: 30 minutes

In this exercise, you will set up your environment for use for the rest of the exercises. This will involve downloading the assets from the repository and deploying them to Azure. We will use your workstation to set up the environment and connect to Virtual Machines via Remote Desktop.

### Task 1: Set up the environment

1.  Open your browser to <https://aka.ms/appmodernization>
2.  Click on the **Deploy to Azure** button

    ![App Migration & Modernization Workshop GitHub Repository](./media/image2-github-deploy-to-azure.jpeg)

3.  Select an **Azure Subscription**
4.  Create a new **Resource Group**
5.  Chose the **East US** location

    ![ARM Template Parameters](./media/image3-arm-template-deployment.jpeg)

6.  Accept the terms and conditions
7.  Click on the **Purchase** button

    ![ARM Template Deployment](./media/image4-accept-terms-and-conditions.jpeg)

**Exit criteria**

- Initiate the environment deploy from the repository
- Verify the website runs in Azure (IaaS)
- Note the URLs of the provisioned web for future reference
- Save the database connection string for later

**References**

- [What is Azure Resource Manager?](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview)
- [Azure Quickstart Templates](https://azure.microsoft.com/en-us/resources/templates/)
- [Azure Virtual Machine Extensions](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/features-windows)
- [PowerShell Desired State Configuration](https://docs.microsoft.com/en-us/powershell/dsc/overview/overview)
- [PowerShell Gallery](http://www.powershellgallery.com/)

**Default Settings**

- VM Admin User Name: sysadmin  
- VM Admin User Password: Password$123
- Database Login Name: workshopServiceAcc  
- Database User Name: workshopServiceAcc  
- Database User Password: P2ssw0rd
- Database Name: partsUnlimitedDB

**Note**: if you don't have a Visual Studio Enterprise License, please select the community edition for the Dev Workstation OS Version.

**Note:** Do not modify the values for **\_artifacts Location** or **\_artifacts Location SAS Token**.

  ![ARM Template Deploying](./media/image5-deployment-tile.jpeg)

Clicking on the tile will show you deployment information and status. This shows all the parameters that were used as part of your deployment, and at the bottom of the blade, will show you the deployment status:

  ![ARM Template Operation Details](./media/image6-arm-deployment-status.jpeg)

Refreshing the blade will update the deployment status.  The deployment will first create the vNet, then the web and SQL servers in parallel, and finally create the developer workstation and deploy the app. The entire process should take between 18 and 25 minutes.

You can navigate away from this page and review the resource group. In the top right of the resource group, you will also see deployment information.

  ![ARM Template Deployment Status](./media/image7-resource-group-deployments.jpeg)

Clicking this link will take you to the list of completed and active deployments

  ![ARM Template Deployment Status](./media/image8-resource-group-deployments-details.jpeg)

Once the deployment is complete, review the vmweb01 configuration to find the public URL.  Copy the URL, open a browser, and paste and go to verify that everything worked correctly.

  ![VM Web 01 URL](./media/image9-vm-dns-name.jpeg)

You should see the Parts Unlimited web site launch like below.

  ![Parts Unlimited Web App](./media/image10-vm-web-app-running.jpeg)

### Task 2: Validate you can connect to the Development Environment

Now that the environment is set up, we need to make sure we can connect to the development environment where we will be doing the exercises for this workshop.

1. Verify connectivity to the development virtual machine
2. Sign in to Visual Studio
3. Remote into the vmdev01 using the User Name and Password used when creating the environment.

    ![VM Sign In](./media/image11-vm-credentials.png)

4. Click **“Sign In”**. Type your Microsoft Account or Corporate Account, whichever account name you use for your Visual Studio Subscription (MSDN).

    ![Visual Studio Sing In](./media/image12-vs-sign-in.png)

5. Open the Solution which is located at **C:\\Source\\AppWorkshop\\IaaS2PaaSWeb\\IaaS2PaaSWeb.sln**

Write the values defined during the setup:

Web Site URL: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

VM User Name: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

VM User Name Password: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

While this is just the initial setup process, note that everything has been automated using a combination of Azure Resource Management Templates, PowerShell, and PowerShell DSC. This technique can be used to support a DevOps process even if you are deploying to IaaS based environments.

## Exercise 1: Migration to Azure PaaS

**Duration**: 30 minutes

Parts Unlimited is in the auto part business. They typically sell via a brick and mortar store but have invested in a small e-commerce presence to augment those stores. They have seen an uptick in use from customers and have been getting some complaints about the speed of the site and requests for additional features and functionality.

Parts Unlimited would like to expand and improve their ecommerce presence, experiment with new features and business strategies to help grow the business. However, they are not interested in sinking large sums of money into hardware and the management of that hardware. They want to quickly spin something up to see how it works, scale it if it
does, and deprovision it if it doesn’t. They also want more flexibility in how they scale their solutions given the seasonal nature of what they do.

Currently, Parts Unlimited consists of an ASP.NET 4.5.1 website running on Microsoft Windows 2016 and SQL database running on Microsoft SQL 2016. You need to migrate that application to a Microsoft Azure App Service Web Site and a Microsoft SQL Azure Database.

With the website migrated, you immediately gain new capabilities that you can use to improve your site and accelerate business value:

- Deployment Slots
- Testing in Production
- Scale up / Scale out
- Authentication Support for Azure AD, Facebook, twitter, etc.
- Diagnostic Tools
- Security Center
- No OS to manage or patch

These features setup Parts Unlimited for future enhancement and scale without having to plan for and manage infrastructure.

**References**

- [App Service Overview](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview)
- [App Service Migration Tool](https://appmigration.microsoft.com)
- [Azure SQL Database](https://docs.microsoft.com/en-us/azure/sql-database/)
- [Azure Data Migration Tool](https://docs.microsoft.com/en-us/sql/dma/dma-overview?view=sql-server-2017)

### Task 1: Migrate the Website to Azure PaaS

In this task we will migrate the web front end to Azure PaaS and leave the database in place.  To allow the PaaS web application to access the database, we will setup a hybrid connection.

1. Connect to the **vmweb01** virtual machine

     ![Migrated App & Database](./media/image14-connect-to-vm.jpeg)

2. When you first connect, Server Manager will open.  To make is simpler to browse the web, let's turn off IE Enhanced Security.
   
    a. Click on Local Server.  You will see an option for IE Enhanced Security, click it

     ![Local Server Manager](./media/image16-local-server-manager.jpeg)

    b. Toggle both to Off

     ![Disable IE Enhanced Security Configuration](./media/image17-disable-ie-enhanced-configuration.png)
   
3. navigate to the [App Migration Tool](https://appmigration.microsoft.com) site.

  ![](./media/e1t1i1.png)

4. First, enter the URL to the website hosted on your VM to assess your sites compatibility with Azure App Service and click 'Assess'

  ![](./media/e1t1i2.png)

5. The tool will attempt to asertain which technologies your web application is using and alert you to any potential blockers.  After review, click the 'Start Migrating Now!' button to download the tool.

  ![](./media/e1t1i3.png)

6. Click the 'Download' button to download the migration tool.  NOTE: ensure you are working from the Web Server VM.

  ![](./media/e1t1i4.png)

7. Once the migration tool has been downloaded to your Web Server, run the migration tool to start the process.  NOTE: you may receive an Migcheck.exe error.  If you do, simply close and restart the migration tool.  This is a known bug that will be fixed in the future.

  ![](./media/e1t1i5.png)

  ![](./media/e1t1i6.png)

8.  Click on the 'Default Web Site' and then click the 'Next' button.

  ![](./media/e1t1i7.png)

9. You will be shown another assessment report.  This will potentially have more information since the tool has access to the web server itself.  Click the 'Next' button.

 ![](./media/e1t1i8.png)

10. You will not be prompted to authenticate with Azure.  You will be given a code and prompted to enter that code into a browser where you have authenticated with Azure.  Copy the code and paste it into your browser, then click 'Continue'.

  ![](./media/e1t1i9.png)

  ![](./media/e1t1i10.png)

11. Next we will fill out some config information so the migration tool can create and configure the appropriate Azure services;
- Subscription: select your prefered subscription.
- Resource Group: choose the 'create new' option and enter a name for your resource group.  Note: this is the resource group we will use for all the PaaS/Serverless resources, please write it down.
- Destination Site Name: choose an appropriate name for your website.  NOTE: the tool will check the availability of the name you choose.
- Region: choose the region which is pysically closest to you
- Databases: check the 'set up Hybrid Connection' check box and enter vmsql01 as the on-prem database server and 1433 as the port.

 ![](./media/e1t1i12.png)

After filling out the form, click the 'Migrate' button to start the proces.

 ![](./media/e1t1i13.png)

12.   Once the tool has completed migrating the website, it will walk you through setting up the Hybrid connection.  Again, make sure you are running on the WebSrv vm.  Download and install the hybrid connection to this server.  Then click 'Next' to continue.
 
   ![](./media/e1t1i14.png)
   
   ![](./media/e1t1i15.png)

   ![](./media/e1t1i16.png)
     
13. Once the migration process has been completed, click the 'Go To Your website' and verify that the migrated site runs correctly

  ![](./media/e1t1i17.png)

  ![](./media/e1t1i18.png)

**Exit criteria**

- An Azure App Service instance should be created with the application
- A Hybrid Connection should be created and configured 
- The application runs against the database running on your SQLVM

### Task 2: Setup Traffic Manager (Optional)
This is an optional step.  Traffic manager will load balance across any public endpoint.  This allows us to load balance between our WebVM (IaaS/OnPrem) environment and our PaaS service.  This could be useful in many situations.

Our intent is to use traffic manager as a way to gradually move our web servers to Azure PaaS.  Later, We will use traffic manager to facilitate our site running in more than one region.

1. Open the Azure portal and navigate to the Resource Group you created when using the App Service Migration tool (Ex 1, Task 1, Step 11).  Click the 'Add' button to add a new service.

  ![](./media/e1t2i1.png)

2. Enter 'traffic manager' and hit enter to search for the traffic manager service and select the 'Traffic Manager profile' published by Microsoft.

  ![](./media/e1t2i2.png)

3. Click 'Create'

  ![](./media/e1t2i3.png)

4. Configure the settings for traffic manager
   - Name: Whatever you want
   - Routing method: performance
   - Subscription: the same subscription you deployed your app service to
   - Resource Group: the same resource group you deployed your app service to
 
   Then click 'Create'.  In a few moments, a traffic manager service will be provisioned into your resource group.

  ![](./media/e1t2i4.png)

  ![](./media/e1t2i5.png)

1. Click on traffic manager and select 'Endpoints' then click 'Add'

  ![](./media/e1t2i6.png)

6. You will configure the IaaS/OnPrem endpoint first.  Enter the following;
   - Type: Azure Endpoint
   - Name: IaaSEndpoint
   - Target resource type: Public IP Address
   - Target Resource: vmweb01PubIp

   Click 'OK' when finished

  ![](./media/e1t2i7.png)

7. You will now configure your second endpoint which will point to your App Service Web App.  Enter the following;
   - Type: Azure Endpoint
   - Name: PaaSEndpoint
   - Target Resource Type: App Service
   - Target Resource: Your App Service Name

   Click 'OK' when finished

  ![](./media/e1t2i8.png)

8. Click on Endpoints in the left menu.  Note that the monitor status will say 'Checking endpoint'.  Wait a little while and then click the 'refresh' button.  Repreat the refresh every minute or so until the monitor status reads 'Online'.  Once online, browse to the DNS name and verify traffic manager is working correctly.  The DNS name can be found in the traffic manager overview.

  ![](./media/e1t2i9.png)

  ![](./media/e1t2i10.png)

**Exit criteria**

- A Traffic Manager Service has been created
- Traffic manager has been configured to leverage both your IaaS web endpoint and your PaaS web endpoint.
- Your website renders via the traffic manager endpoint

### Task 3: Migrate the Data to SQL Azure
So far, we have been running against the database running on our VM.  In this task, we are going to migrate the database schema and data to Azure SQL.  We will use the SQL Data Mimgration Tool for this task.

1. Download the [Data Migration Tool](https://docs.microsoft.com/en-us/sql/dma/dma-overview?view=sql-server-2017) and install on any of the VMs.


2. Run the Data Migration Tool, click the '+' button and add a new Assessment.  Give the assessment a name, choose the source server type as SQL Server, the target server type as Azure SQL Database, and click 'Create'

  ![](./media/e1t3i1.png)

3. Leave the default options and click 'Next'

 ![](./media/e1t3i2.png)

4. Select the datasource.  Enter vmSql01 as the server, pick Windows Authentication as the Authentication type, and select Encrypt connection and Trust server certificate, then click 'connect'

  ![](./media/e1t3i3.png)

5. Select the 'partsUnlimitedDB' and then click 'Add'

  ![](./media/e1t3i4.png)

6. Click 'Start Assessment'

  ![](./media/e1t3i5.png)

7. Review the assessment to see if there are any outstanding issues.

  ![](./media/e1t3i6.png)

8. Seeing that there are no blocking issues, click the '+' button again, select 'Migration', fill out a project name, pick SQL server as the source and azure SQl as the target.  Lastly pick schema and data for the migration scope then click 'create'.

  ![](./media/e1t3i7.png)

9. After creating, you will be shown the migration project you just created and where you are in the migration process.  Click 'connect' to start the process.

  ![](./media/e1t3i8.png)

10. Select the database that you want to migrate, in this case, the partsUnlimitedDB.  Then click 'Next'.

  ![](./media/e1t3i9.png)

11. Before we can select the target, we need to fist create an Azure SQL Server and Database.  Open the Azure portal and go to the resource group containing your app service and traffic manager.

  ![](./media/e1t3i10.png)

12. Click the '+' button in your resource group and enter 'sql' and select 'SQL Database' by Microsoft.

  ![](./media/e1t3i11.png)

  ![](./media/e1t3i12.png)

13. In the 'Create SQL Database' dialog, enter;
      - Subscription: your subscription
      - Resource Group: The resource group containing your app service and traffic manager
      - Click 'Create New' for the database server

      ![](./media/e1t3i13.png)

14. You will be prompted to create a new server.  Provide a server name, server login, password, and location.  Check the box allowing azure services to access the server.  Click 'select'.  NOTE: put the database server in the same region as your app service.  NOTE: please write down the database password for future use.

  ![](./media/e1t3i14.png)

15. Once you have selected finished filling out the information for your new database server, you will be taken back to the create sql database page with the server information filled out.  Select 'No' for the elastic pool option and select 'Standard S0' as the database size.  Click 'Review and Create'.

  ![](./media/e1t3i15.png)

16. Review the configuration and then click 'create' to provision an Azure SQL Server and then an Azure SQL database on that server.

  ![](./media/e1t3i18.png)

17. When complete, you will be shown a deployment summary.  Click the link to the resource group where you deployed the server and database.  This should be the resource group containing your app service and traffic manager service.

  ![](./media/e1t3i19.png)
  ![](./media/e1t3i20.png)

18. We need to lookup the full name of our SQL server for use with the data migration tool.  Within your resource group, click on your SQL Server, then click 'properties' in the left menu.  Copy the server name, you will enter this in the data migration tool.

  ![](./media/e1t3i21.png)

19. Next we need to configure the firewall rules on the SQL server such that the Migration Tool is able to connect.  NOTE: you must be browsing the azure portal with the same VM where the migration tool was installed.  On the SQL Server Overview page, click 'Show Firewall Settings'

  ![](./media/e1t3i22.png)

20.  Simply click 'Add Clint IP' and then click 'save'

  ![](./media/e1t3i23.png)

21.  Now, go back to the Data Migration Tool and enter the Azure SQL Server name, choose SQL authentication, enter the user you configured, the password for the user, and click 'connect'

  ![](./media/e1t3i24.png)

22.  Select 'partsUnlimitedDB' as your target database and click 'Next'

  ![](./media/e1t3i25.png)

23.  Select all the tables and users and then click 'Generate SQL Script'

  ![](./media/e1t3i26.png)

24.  You will be shown the generated SQL script which will create the objects you selected on the previous screen.  Click 'Deploy Schema' to create the schema in our SQL Azure database.

  ![](./media/e1t3i27.png)

25.  As the schema is deployed, you will see a list of successfully created objects be generated.  Once done, click  'Migrate Data' to move your data to SQL Azure.

  ![](./media/e1t3i28.png)

26.  Ensure that all the database tables have been selected and click 'Start Data Migration' to start the migration process.

  ![](./media/e1t3i29.png)

  ![](./media/e1t3i30.png)

27.  At this point, your data has been migrated to SQL Azure.


**Exit criteria**

- A SQL Azure Server has been created
- A SQL Azure Database has been created
- Data and Schema has been migrated to SQL Azure

### Task 4: Finalize Migration
Almost done.  We need to configure our app service to use SQL Azure , remove the Hybrid connection, and have traffic manager only use the App Service Endpoint.

1. Go to the resource group containing traffic manager and click on your traffic manager instance.

  ![](./media/e1t4i1.png)

2. Click on the IaaSEndpoint.

  ![](./media/e1t4i2.png)

3. Select to 'Disable' the endpoint then click the 'Save' button.

  ![](./media/e1t4i3.png)

4. Next we need to grab the connection string for your SQL Azure database.  Back to your resource group, click on the partsUnlimitedDB.

  ![](./media/e1t4i4.png)

5. On the overview page, click the 'Show database connection strings' link and copy the connection string.  NOTE: the connection string will not contain user name and password information.  You will need to edit the connection string to provide this.

  ![](./media/e1t4i5.png)

6. Back to the resource group, click on your app service.

  ![](./media/e1t4i6.png)

7. Within your App Service, click on the 'Configuration (Preview)' menu, then click on 'Application Settings'.  Next, click the 'New connection string' button.  Copy the connection string containing your user name and password, click 'Update', then click the 'Save' button.

  ![](./media/e1t4i7.png)

8. Right now, all connections are using the Hybrid Connection.  Before our App Service can reach our SQL Database, we need to delete the Hybrid Connection.  In your app service, click the networking menu, then click to configure Hybrid Connections.  Delete the Hybrid Connection.

  ![](./media/e1t4i8.png)

9. Your App Service Web App should be connected to your SQL Azure Database.  Browse to your web application and verify everything is working correctly.


10. If you like, you can uninstall the Hybrid Connection client from your VM and/or delete the IaaS endpoint within traffic manager.


**Exit criteria**

- Traffic Manager has been configured to only point to Azure App Service
- The web application has been configured to use SQL Azure
- The Hybrid connection has been removed from the app service
- Optionally, you have removed the IaaS endpoint and uninstalled the Hybrid Connection client.

## Exercise 2: Implementing DevOps Continuous Integration / Continuous Deployment (CI/CD)

**Duration**: 45 minutes

Parts Unlimited wants to improve their deployment process to enable more agility. Currently, Parts Unlimited has a very manual deployment process. Developers document the install steps and operations performs the deployment. This process worked when they pushed code only a few times a year. However, the goal is to rapidly deliver value in days as opposed to months.

Currently, there is no automated deployment process.  has been chosen as the ALM/DevOps platform moving forward. You will implement a CI/CD process from Team Services to Azure. Once the CI/CD process is in place you can quickly deploy changes to production with full traceability. The automation not only shortens your delivery time, it also dramatically improves the repeatability. Additionally, you can add unit testing, automated UI testing, Load Testing, Manual Testing, approval processes, etc. to ensure you do not sacrifice quality for speed.

**References**

- [Azure DevOps Services](https://www.visualstudio.com/team-services/)
- [Azure DevOps Services CI/CD](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-vsts-iis-cicd)

**Prerequisites**

You must also have a Azure DevOps Services Organization Account and be able to create new projects within that account. If you don’t, you will need to [create one](https://docs.microsoft.com/en-us/vsts/accounts/create-account-msa-or-work-student?view=vsts).

**Note**: Setup Azure DevOps with the same user account you use to log into the Azure Portal.  If you do not, the CI/CD wizard will not find your subscription automatically\!

### Task 1: Add a new project to Azure DevOps and upload the code

- Create Team Services Project and upload code
- Use Quick DevOps capabilities out of portal
- Verify build/release process
- Add deployment slots
- Update release to use deployment slots
- Verify release

1. Once you have a Azure DevOps subscription setup, log into your tenant and create a new project:

    ![Azure DevOps - Create New Project](./media/image48.jpeg)

2. Give your project a name, make sure you have Git as your version control system, and click create.

    ![Azure DevOps - Create New Project Options](./media/image49.jpeg)

3. In a few moments you will have a new project provisioned for you.  You are now ready to upload code.

    ![Azure DevOps - Project Created](./media/image50.jpeg)

4. Next, we are going to change the origin of our Git repo and push an it to Azure DevOps.  If not already visible, you can navigate to the **Repos \> Files** of Azure DevOps where you will be presented with the commands (with some small changes) to push the code to the repo.  This will be specific to your Azure DevOps subscription and your project name so type in what Azure DevOps shows you.

    ![Azure DevOps - Repository](./media/image51.jpeg)

### Task 2: Upload Code to Git Repository in Azure DevOps

1. Connect via Remote Desktop to the **vmdev01** virtual machine using the User Name and Password provided when creating the environment.

    ![Remote Desktop Connection](./media/image52.png)

    > **Reminder**:
    >
    > Default Admin: sysadmin
    >
    > Default Password: Password$123

2. Open a command prompt and execute the following commands:

    ```Bash
    C:\windows\system32> cd C:\Source\AppWorkshop
    C:\Source\AppWorkshop> git remote set-url origin <REPO URL>
    C:\Source\AppWorkshop> git push -u origin --all
    ```

    > **Note**:
    >
    > The \<REPO URL\> must be replaced with:
    >
    > ![Azure Repos](./media/image54.png)

3. You’ll be prompted for your credentials.

    > ![Sign into Azure DevOps](./media/image55.png)

4. After you have entered your credentials, your commit will be pushed to Azure DevOps.

    > ![Commit progress](./media/image56.png)

5. Once you entered the commands, refresh the browser.  You should now see the workshop code in your Azure DevOps repository.

    > ![Azure Repos](./media/image57.png)

### Task 3: Use App Service Deployment Center to create CI/CD

1. Go back to the Azure portal and open the Azure App Service Web Site you created when you used the Migration Tool. It will be in the **Server-Migration-XXXX** resource group.

2. You will want to pick the "Deployment Center”

    > ![App Service Deployment Center](./media/image58.png)

3. Next, you will see an overview page, click **Azure Repos** and click **continue**.

    > ![Source Control](./media/image59.png)

4. Next, you’ll have a choice of Build Providers, App Service Kudu build server or Azure Pipelines. Click on **Azure Pipelines (Preview)**

    > ![Build Provider](./media/image60.png)

5. Configure where the source code is located and which Web Application Framework to use for your Build, in this case use ASP.NET.

    > ![Configure](./media/image61.png)
    >
    >  **Note**:
    >
    >  If you don't click on each dropdown, the OK button won't enable.

6. In the **Deploy to staging** step, select **Yes** to enable deployment slot and **New** to create a new slot, provide the name **Staging** and click **continue**.

    > ![Deploy to Staging](./media/image62.png)

7. You should see a summary like the following:

    > ![Summary](./media/image65.png)

8. Verify the configuration and then click **Finish**.

The service will create the Build and Release Pipelines in Azure DevOps, create a new Web Application for Staging and trigger a build.

This process may take a few minutes. When its complete, you’ll see a summary screen like the following:

![Deployment Center configured](./media/image66.png)

Going back to Azure DevOps, click on Pipelines, then click on Builds. You should see the build definition that was generated for you.

![Azure DevOps - Build Pipeline](./media/image67.jpeg)

Next, click on the Releases tab to see the release that was generated
for you.

![Azure DevOps - Releases](./media/image68.jpeg)

After a little time, the release should complete.

![Azure DevOps - Releases ](./media/image69.png)

**Note**:

Looks like there is a bug in the migration tool.  It doesn't property put the connection string in the app settings correctly. Remember how we fixed this before?

![Deployment error](./media/image70.jpeg)

**Note**: This is an opportunity to see how you can troubleshoot the environment using Kudu, diagnostics, deployment slots, etc. Navigation with your web browser to 

``` 
https://\[webname\].scm.azurewebsites.net
``` 

To Avoid the error……….

Note that the name of the connection string is "DefaultConnectionString", which we captured before starting the CI/CD pipeline creation.

> ![Connection String Error](./media/image71.jpeg)

When the migration tools moved the application, it doesn't correctly add
the connection string name.  Note that the connection string is simply
"DefaultConnection"

> ![App Service - Applicagion Settings - Connection String](./media/image72.jpeg)

To avoid an error, simply edit the connection string name in both the production website and the staging slot to read "DefaultConnectionString" and save your settings. For the Database, use **SQLAzure**.

**Note**:

If you’re using Azure DevOps, consider managing ConnectionString values in Release using the appropriate task.

### Task 3 (Alternative): Use Azure DevOps to create CI/CD

Go back to the Azure portal and open the Azure App Service Web Site you created when you used the Migration Tool. It will be in the Server-Migration-XXXX Resource Group.

**Part A - Setup A Deployment Slot**

1. Open the Server-Migration-\*\*\*\* resource group and click on the web application

    > ![Server Migration Resource Group](./media/image73.jpeg)

2. In the web application, click on Deployment Slots

    > ![Web App Deployment Slots](./media/image74.jpeg)
    >
    > At this time, there are no deployment slots configured for your website.  A deployment slot is used to setup a staging environment for your application, so you can test new changes easily prior to rolling them to production.

3. Click the Add Slot option to add a new deployment slot.

    > ![Add Deployment Slot](./media/image75.jpeg)

4. On the "Add a Slot" dialog, name the slot "staging" and choose the configuration source as the current production slot, then click ok.

    > ![Staging Deployment Slot](./media/image76.png)

5. When done, you should have a new deployment slot named "staging".

    > ![Staging Deployment Slot](./media/image77.jpeg)

**Part B - Setup CI/CD**

1. Open your new Team Services Account \*\*\*\*.VisualStudio.Com and view the "Overview".  You should be presented with summary information about your project with a very prominent "Set up Build" Button….. Click it.

    > ![Setup CI/CD](./media/image78.jpeg)

2. The Next Dialog will ask you to choose where your source code is, your project, repository, and branch.  These options should be defaulted to the correct values.  Click continue.

    > ![Choose source control provider](./media/image79.jpeg)

3. The next dialog will present you with a few canned build templates.Select the **ASP.NET** template and click Apply.

    > ![Select build template](./media/image80.jpeg)

4. Next, you will be shown the build process with some options that need to be configured.  First, in the "Azure Subscription" drop down, pick the Azure subscription which is hosting your migrated web application and then click the "Authorize" button.

    > ![Authorize service connection](./media/image81.jpeg)
    >
    > **Note:** It is assumed that you are using the same login for your Azure DevOps account and your azure subscription.  If this is not the case, the Azure subscription may not be shown in the drop down and you will need to manually add it to Azure DevOps.  If this is the case, simply ask your instructor or proctor to assist you.  Should take no more than a few minutes to setup.

5. Once the subscription has been Authorized, Azure DevOps is able to enumerate the App Services in your subscription and populate the drop down.  Simply pick the App Service you wish to deploy to.

    > ![Select App Service Name](./media/image82.jpeg)

6. One last setting.  Notice that the "Triggers" tab is showing an error. Click the triggers tab and select your master branch.

    > ![Branch filters](./media/image83.jpeg)
    > ![master branch filter](./media/image84.jpeg)

7. Lastly, save and queue your build to verify it works correctly.

    > ![Save and queue build pipeline](./media/image85.jpeg)

8. Add a comment to note the changes made to the build definition and click the "Save & Queue" button.

    > ![Add comment to save and queue build](./media/image86.jpeg)
    > You will see that the build was successfully saved and a new build has been queued.

9. Click the new build link so you can watch the progress.

    > ![New build link](./media/image87.jpeg)

10. Clicking on the "Logs" tab will let you review detailed, real time, build information.

    > ![New build progress](./media/image88.jpeg)
    > ![Build success](./media/image89.jpeg)

**Part C - Leverage the Deployment Slot and implementing a Release**

1. While we are deploying our application as part of a build, it may be a better option to leave the creation of artifacts to the build and move deployment of said artifacts to a release.  To quickly create a new release, click the "Create Release" option.

    > ![Create release](./media/image90.jpeg)

2. Just like when creating a new build, you are presented with a selection of templates to use as your starting point.  Select the "Azure App Service Deployment" template and click "Apply".

    > ![Select release pipeline template](./media/image91.jpeg)

3. Just like the build, we need to configure the task to deploy to our Website.  Click the error showing for "1 phase, 1 task" to get started.

    > ![Pipeline stages](./media/image92.jpeg)

4. Next you are shown options to configure the subscription, app type, and app service name.  These should all be available in the drop downs.

    > ![Stage details](./media/image93.jpeg)

5. Almost done, we just want to make a couple of additional modifications to take advantage of the deployment slot we configured earlier. Click the "Deploy Azure App Service" task so we get access to all the configuration options.  We will want to check the "Deploy to Slot" check box, pick the resource group, then select the "staging" slot that we configured earlier.

    > ![Deploy Azure App Service](./media/image94.jpeg)

6. At this point, the release will simply deploy to our staging slot and nothing will be changed in production until we swap production with staging.  We can do this as part of our release by adding another task. Click on the "+" to add a new task.  Search for "Swap" and add the "Azure App Service Manage" task to your release process.

    > ![Add Azure App Service Manage Task](./media/image95.jpeg)

7. Once added it will need a little configuration.

    > ![Swap Slots Task](./media/image96.jpeg)

8. You will want to select your subscription, pick the app service, pick the resource group, and pick the source slot.  Finally click "Save"

    > ![Swap Slots Task](./media/image97.jpeg)

The CI/CD pipeline is complete.  Queue a new build and follow the build/release to verify it works correctly.  Follow the build process and then follow the release process.

**Note:** While we are moving the deployment capabilities to the release and using deployment slots, we did not create multiple environments to save time.  If you like, you could create a new environment in the release and move the "Swap Slots" task to the second environment and add approval processes.

## Exercise 3: Detect, Diagnose, Monitor Application Performance with Application Insights

**Duration:** 45 minutes

Parts Unlimited understands that bad experiences online will quickly drive a customer to your competitor. With that in mind, they want to gain better visibility into issues customers are experiencing while using their site.

In addition to gaining better insights into the sites health, they are also interested in better understanding how customers are using the site and the sites effectiveness.

As there is no instrumentation on the site today, they have decided to add Application Insights telemetry.

Timely actionable telemetry is an important aspect of any modern application. Actionable information is a vital component of any DevOps practice.

- Add Application Insights to the web app
- Modify the code to instrument the app
- Test locally to verify the app works
- Push the changes to kick off a release
- Test that the production application works
- Review App Insights Data

**References**

- [Azure Application Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview)

### Task 1: Create an Application Insights Instance

Go to the resource group created by the migration tool.  You should see your application services.

Click on the Application Insights Menu Item to create a new instance 

> ![Resoure Group - Application Insights](./media/image100.jpeg)
>
> ![Create Application Insights](./media/image101.jpeg)
> 
> ![Create Application Insights - New Resource](./media/image102.png)

Enter a name for the Azure Application Insights instance and choose the region where it should be deployed. Choose the runtime/framework your application is using. In this case, choose ASP.NET. Click OK to create.

> ![Apply monitoring settings](./media/image103.png)

At the top of the pane, you’ll see a notice telling you the application will modify your Application Settings and will restart your site.

Deployment should only take a few moments.

When deployment is finished, go back to your resource group.  You should now see your App Insights Instance.

> ![Application Insights Resource](./media/image104.jpeg)

### Task 2: Update your Web Application to use Application Insights

Remote into the vmdev01 using the User Name and Password used when creating the environment.

> ![Remote Desktop Connection to vmdev01](./media/image52.png)

**Note**:

Default Admin: sysadmin
Default Password: Password$123

> ![Remote Desktop Connection Certificate Warning](./media/image11-vm-credentials.png)
> ![Remote Desktop Connection Certificate Warning](./media/image53.png)

On your developer workstation, open the solution.

Right click on the web application and choose to add Application Insights telemetry

> ![Remote Desktop Connection Certificate Warning](./media/image105.jpeg)
> ![](./media/image106.png)

You will be presented with a dialog, click **Get Started** to continue.

This will bring up the Registration Dialog.

> ![Application Insights Visual Studio Registration Dialog](./media/image107.png)

You will want to select your subscription and select the Application Insights resource we just created and click **Register**

> ![Application Insights Visual Studio Registration Dialog](./media/image108.png)

In a few moments, your application will be instrumented and registered.

Lastly, we will enable trace collection.  Simply click the "**Collect traces from System.Diagnostics**" to enable.

> ![Application Insights - Enable Trace Collection](./media/image109.png)

This should leave you 100% configured

> ![Application Insights - Configured 100%](./media/image110.png)
> 
We need to update a package, so right click on the project in visual studio and select "Manage NuGet Packages.."

> ![Update Application Insights NuGet Dependency](./media/image111.jpeg)

There are a lot of packages that need to be updated, but we are only going to update one package.

We are looking for **System.Diagnostics.DiagnosticSource**. Select that package and click the update button.

> ![Update System.Diagnostics.DiagnosticSource NuGet Package](./media/image112.jpeg)

Run your web application and verify everything runs correctly.

**Note:** You want to move the instrumentation key to the Web.Config. This lets you override the key in production and easily use multiple keys. This blog has a nice post on how to do that:

[https://blogs.msdn.microsoft.com/devops/2015/01/07/application-insights-support-for-multiple-environments-stamps-and-app-versions/](https://blogs.msdn.microsoft.com/devops/2015/01/07/application-insights-support-for-multiple-environments-stamps-and-app-versions/)

### Task 3: Update your application to provide client side telemetry

Azure Application Insights gives you a lot of information without doing anything else.  However, we want a little more, so we are going to make some changes.

Open the **\_Layout.cshtml** file located in the **views\\shared** folder.

> ![Enable Client Side Telemetry](./media/image114.jpeg)

There is a section commented out that will send telemetry from the web page. We are going to simply enable this code to allow capturing client side telemetry.

> ![Enable Client Side Telemetry](./media/image115.jpeg)

If you want, you can rerun the application to ensure it works correctly.

### Task 4: Implement the Custom Event Telemetry Provider

A custom Event Telemetry Provider has been written, but the implementation needs to be uncommented before it can be used. Navigate to the **Utils** folder and edit the **TelemetryProvider.cs** file by uncommenting the code and add to the top of the class **using Microsoft.ApplicationInsights;**. This provider wraps the Azure Application Insights SDK TelemetryClient and is used to record custom events such as messages, traces, and exceptions. Its use can be found in the **OrdersController.cs** or **ShoppingCartController.cs** classes.

> ![TelemetryProvider.cs](./media/image120.png)

**Note**: You can find all the code that needs to be uncommented by using the **View -> Task List** menu in Visual Studio and filtering by the phrase "Application Insights - Uncomment".

### Task 5: Push your code to production

With everything running locally, time to push our changes to production.

In Visual Studio, go to the team explorer, then go to changes.

> ![Team Explorer](./media/image121.jpeg)

Add a comment and then commit and push

> ![Commit changes](./media/image122.jpeg)

After a few moments you should get a success dialog

> ![Changes Sync](./media/image123.jpeg)

You shouldn't have to do anything at this point, the build and release will automatically kick off.

> ![Azure Pipelines - Build Triggered](./media/image124.jpeg)
>
> ![Azure Pipelines - Build Success](./media/image125.jpeg)
>
> ![Azure Pipelines - Release Triggered](./media/image126.jpeg)
>
> ![Azure Pipelines - Release Success](./media/image127.jpeg)

Before moving to the next step, open a browser and navigate to the site. Verify that your release was successful by viewing the source code in the browser to ensure the Application Insights key was deployed to the Web Application in Azure. You can do this by viewing the HTML source code and look for Application Insights instrumentation key in the ```<head />``` block. Move around the site to generate data that will be used in the next activity.

### Task 5: Review the data

Go back to your resource group and open Application Insights.

> ![Applicatin Insights Resource](./media/image116.jpeg)

Now let’s create a dashboard for this application. Click on the **Application Dashboard** link.

> ![Applicatin Insights - Create Dashboard](./media/image128.png)

This will give us some core information around Usage, Reliability, Responsiveness, and the Browser.

> ![Applicatin Insights Dashboard](./media/image129.png)

Click the **App Map**

> ![Applicatin Insights - Application Map](./media/image130.jpeg)

### Task 6: Web Test

Now we want to monitor the web application from different locations and get a better understanding of what other users in different regions are experiencing. Under the Investigate pane, click on **Availability**. This will bring up a new blade that will allow you to add the new test. Click on **Add Test**.

> ![Applicatin Insights - Add Availability Test](./media/image131.png)

Type “Monitor Application” for the “Test Name” and click on the **Test Locations** and choose where you would like the application to be monitored.

> ![Applicatin Insights - Add Availability Test](./media/image132.png)

At this point, we’re only going to do a simple **URL ping test** to
verify that we’re getting a HTTP 200 returned from the application.

![Applicatin Insights - Add Availability Test Alerts](./media/image133.png)

Last, before we create this new test, we want to set how we will be alerting if we do get something other than a HTTP 200 response. In the “send alerts emails to these email address” textbox, type in your email address. At this time, no Webhook will be called and this can be left blank. We done, click OK to continue.

**Note**: There are many alerts possible and Azure Application Insights is integrated with Azure Monitor.

Click **Create** to create the test.

In a few minutes, the Availability Test Summary will be updated, and you will see test results from the of the locations you’ve chosen.

![Applicatin Insights - Availability Test Summary](./media/image134.png)

## Exercise 4: Optimize and Protect Azure Web Application

**Duration**: 45 minutes

While the default settings for deploying web application may work in any situations, we want to examine our Azure App Service Web Application and ensure its secure, optimized, and able to meet the demands of our customers. We will use the Azure portal to configure the ensure backups, logging is enabled, and the application is sized and can scale as need.

This lab will demonstrate how to safe guard and protect your application and make it available by:

- Resource Group cannot be deleted by creating a lock
- Configure backups are setup with 120-day retention
- Ensure the average response time is \< 2 seconds
- Configure alerts exist for CPU \< 90 secs
- Configure diagnostics and exception logging is configured
- Ensure the average CPU \< 20%
- Verify that there’s 35 GB free space available
- Scale up to a premium hosting model with \> 3GB RAM available

Azure App Service services keeps you informed about the state of your application. It provides the ability to safe guard the application by performing automatic backups, provides a consolidate method for collection information about your application, has the ability of scaling up/down and notifying you when it does.

**References**

- [Web Site Backup](https://docs.microsoft.com/en-us/azure/app-service/web-sites-backup)
- [Auto Scaling](https://docs.microsoft.com/en-us/azure/architecture/best-practices/auto-scaling)

### Task 1: Configure Backups

We need to “start right” by getting the backups going before we move forward with too much code changes. Backups will be stored in defined Azure storage account as ZIP files and contain an XML manifest of the ZIP contents. SQL databases will be stored in a BACPAC file that can be imported.

**Note**: Although the ZIP file and BACPAC file can be accessed, altering any of the files will invalidate the backup.

Navigation to the web application in the Azure Portal. Navigate to the **Backups** under the settings section. Click the **Configure** link.

> ![App Service Backups](./media/image135.png)

If we had a Premium App Service Plan, we would be able to run Snapshots. Since we’re running a Standard account, we’ll configure our back up to be performed when the traffic and volume is the lowest.

### Task 2: Configure Storage Account for Backups

We need to define which Azure BLOB storage account to be used for backups. Since we don’t have an account, we’ll create one. Click “Storage not configured” and then on the Storage accounts pane, click the **+ Storage Account** to create a new storage account.

For ease of use, type of same name you use for the application as the name of the storage account. Since this is just a backup account, keep the default **Standard** for Performance and select the same “Location” for the region where the application is being hosted. For Replication, change the setting over to “Geo-redundant storage (GRS)”. Click **OK** and it will take a few moments to provision the new storage account.

> ![Create Storage Account](./media/image136.png)

Once provisioned, select the new storage account from the list. Next, we need to define where the backup will be written. Click **+ Container** and type in the name of the container, such as ‘backup’. The name must be lowercase, at least 3 characters long and no more than 63 in length. Each hypen must be followed by a non-hypen character. We don’t want the container/backups accessible externally, so make sure Public Access level is set to Private, No anonymouse access.

> ![Add backups Container to Storage Account](./media/image137.png)

Click **OK** and the in the Containers list, click on the container to use and click **Select** to pick the container that will be used for the backups.

> ![Select backups Container in Storage Account](./media/image138.png)

Now that our Storage Account and Container has been selected, validate you have the right setting on the Backup Configuration pane.

> ![Confirm storage account configuration](./media/image139.png)

### Task 3: Schedule Backup

Next, since we want the backup to be performed nightly, we need to turn on the scheduled backups by clicking “Scheduled backup” to “On”.

![Enable scheduled backup](./media/image140.png)

The next steps are to define how often we want to perform the back up and how many days we want to retain the backups. We only need to back up daily, so select “1” for Days. We want our backup to kick off at 3:00 AM, type in 3:00 AM. We backups from the last 120 days, type that in the Retention area.

![Define Backup Schedule](./media/image141.png)

### Task 4: Backup Database

Azure App Service has detected a database in use, so we’ll want to include that in the back up as well. Click the **Include** checkmark to also have it backed it. Database backups are available for SQL Database, Azure Database for MySQL, Azure Database for PostgreSQL, and MySQL in-app.

> ![Include database in backups](./media/image142.png)

Validate the backup settings on more time and when you’ve confirmed everything meets your organizations policies, click **Save**.

> ![Confirm database backup settings](./media/image143.png)

Once the backup is defined, Azure will automatically preform its first backup. It may take some time for the backup to appear, it depends on the size of the application and database. For our application, this should take only a few minutes to appear.

> ![Confirm database backup execution](./media/image144.png)

Once a backup has completed, we can use the Azure Portal to navigate to the Container in the Storage Account and see the LOG, XML manifest, and ZIP file containing the files.

> ![Verify backup in storage account](./media/image145.png)

**Partial Backups**

You can also configure Partial backups if you would like to exclude data to limit how much you’re backing up such as logs and image files. 10 GB is the max size available for backups currently.

**Restore Backup**

This is the same page you’ll come to Restore a previous backup.

**Automate Backup**

Like many services in Azure, Application Service backups can also be automated with scripts using either the Azure CLI or Azure PowerShell.

### Task 5: Viewing Health by Reviewing the Response Time and Errors

Navigate to the Application in the Azure Portal. The Overview section gives you essential information about how your application is performing such the Average Response Time, number of Requests, Data In/Out, and Http 5xx. What is the average Response Time for the application?

> ![App Service Metrics](./media/image146.png)

### Task 6: Setting Alerts

Now you’ve seen basic performance information, let’s setup an early warning system. Under the **Monitoring** section for the Web App, click **Alerts (Classic)**. This allows Azure to notify you when certain conditions are of your resources are reached.

We want to create an alert when the CPU raises beyond 70% for a period and be notified. Click **+ Add alert metric (classic).** This as a new rule that will be trigged when the condition is reached. Type the name of the rule such as **High Average CPU**, next set the metric to CPU Time, set the threshold to 70, check the email owners, and type in your email address.

> ![Create alert rule](./media/image147.png)

### Task 7: Configuration App Diagnostics

Once we have the alerting and monitoring in place, we want to be able to record issues as the arise. To enable diagnostics, under the Monitoring section, click on **Diagnostics Logs**. Turn on Application Logging (Filesystem) and Application Logging (Blob), select the level of logging to **Error** for both.

**Note**: To view the Stream Log, logs must be written to local storage.

Next, we select the Storage Account you previously created for backups, create a new container called **app-logs** and select it.

> ![Create logs container in Storage Account](./media/image148.png)

Create another new container called **web-server-logs** and turn on **storage** for the Web server logging.

**Note**: Make sure each container has its access set to private (no anonymous access).

For each log setting, set the retention period (days) to 120.

> ![Diagnostics logs settings](./media/image149.png)

When everything is all set, click **Save**.

### Task 8: Viewing Application CPU/Memory

We need to ensure that we’re “ok” right now. From a CPU/Mem standpoint.

> ![Application CPU/Memory metrics](./media/image150.png)

### Task 9: Viewing Disk space

It’s important that we have room to grow. On the navigation, under the App Service Plan, click on Quotas.

> ![App Service File System Storage Usage](./media/image151.png)

### Task 10: Configuring Auto Scale Up

We know that the site runs poorly on a single CPU box. Let’s fix that first. Navigate to the App Service Plan and **Scale Up** the application to at least to a P2 instance.

> ![App Service Scale Up](./media/image152.png)

### Task 11: Enable App Service Auto Scale Out

An advantage to running in Azure is auto-scaling the application up and down based off the demand. In this lab, we’re going to create an auto scale rule to handle peak loads.

In the search dialog in the Azure Portal, type ‘Monitor’ to navigate to the Azure Monitor Service.

> ![Find resource](./media/image153.png)

Under the Settings section, click on **AutoScale**. From the list of services, select the App Plan to enable.

> ![Enable autoscale](./media/image154.png)

Verify you have the correct **App Plan** and click **Enable** auto scale.

> ![Verify app service plan](./media/image155.png)

Next, set the rules for which the application will scale out and scale back in.

> ![Create autoscale rule](./media/image156.png)

Save the changes

### Task 12: Prepare for scaling in another region

Are you getting heavy traffic from another region or want to improve the high available of your application? Now that we have a Premium App Plan, we can clone the application and all its settings into a new App Service Plan. That plan can be in the same Resource Group or a new Resource Group.

> ![Clone App Service to another region](./media/image157.png)

Once you’ve set up a new App Service Plan and Resource Group, now it’s time to set the Clone Settings.

> ![Configure settings to clone](./media/image158.png)

### Task 13: Viewing Resource Health and History

Now we want to see the overall health history of our resource. Perhaps there was an event that happen that made the application slow to respond or simply want to make sure everything is going already. Navigate to **Resource Health** under the Support + Troubleshooting section. Here you can the current available and the last health events over the last two weeks for the application.

> ![Resource Health](./media/image159.png)

### Task 14: View Auto Scale Run History

To view the history on how often the web application is scaling up / down, click on the **Run History** link.

> ![](./media/image160.png)

### Task 15: Setting up auto scaling notifications

If you want to be notified how when the application is scaled up / down,
Navigate to Notify.

> ![Autoscale Run History](./media/image161.png)

## Exercise 5: Optimize and Secure Azure SQL Database

**Duration**: 45 minutes

While the default settings for deploying SQL database may work in many situations, we want to examine the database and ensure its secure, optimized, and able to meet the demands of our customers. We will use the Azure portal to configure the ensure tuned, diagnostics is enabled, and the database is sized and can scale as need.

This exercise will demonstrate how to safe guard and protect your database and make it available by:

- Database DTU utilization is \< 20%
- \>= 3000 DTUs are available for the database
- Database is accessible only from Azure (not externally)
- Database is failover-ready to another region (without app code change)
- Threat Detection is enabled
- Automatic Tuning is enabled
- Diagnostics are enabled
- Alerts anytime DTU usage is \> 60%
- Database vulnerabilities are automatically discovered

**References**

- [SQL Azure](https://docs.microsoft.com/en-us/azure/sql-database/)
- [Resource Group Locking](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-lock-resources)
- [Transparent data encryption for SQL database and Data Warehouse](https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/transparent-data-encryption-azure-sql?view=azuresqldb-current)
- [Advanced Threat Protection for Azure SQL Database](https://docs.microsoft.com/en-us/azure/sql-database/sql-advanced-threat-protection)
- [Firewall & virtual network rules](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-vnet-service-endpoint-rule-overview)
- [Database Transaction Unit (DTU)](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-what-is-a-dtu)
- [Failover Groups and active geo-replication](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-geo-replication-overview)

### Task 1: Resource Locking

We want to make sure than nobody accidentally deletes this footprint. Unlike role-based access control, you use management locks to apply a restriction across all users and roles. There are two settings: **CanNotDelete** and **ReadOnly**. Locks are only limited to the management of the resource itself, not the function of the resource. For example, a ReadOnly lock on a SQL Database prevents you from deleting or modifying the database, but does not prevent you from creating, updating, or deleting data in the database. Only **Owner** and **User Access Administrator** can create or delete management locks.

Navigate to the SQL Server database in the Azure Portal. In the Settings blade for the SQL server database, select **Locks**.

**Note**: Locks can be applied at a resource, resource group, or subscription that you wish to lock.

> ![Management Locks](./media/image162.png)

Next, in the Management locks, click on **Add**. If you want to create a lock at the parent level, select the parent. The currently selected resource inherits the lock from the parent. For example, you can lock the resource group to apply a lock to all its resources.

> ![Add Management Lock](./media/image163.png)

Give the lock a name and lock level.

> ![Add Name](./media/image164.png)

To delete the lock, select the ellipsis and **Delete** from the available options

> ![Delete Lock](./media/image165.png)
>
> ![](./media/image166.png)

### Task 2: Enable Transparent Data Encryption

If we have sensitive data, we can encrypt the data without impacting the application. Transparent data encryption encrypts your database, backups, and logs at rest without any changes to your application. For newer databases, this service is automatically turned on. You may need to be manually enabled for older databases.

> ![Enable Transparent Data Encryption](./media/image167.png)

If you want to supply your own key (BYOK), you can store it on Azure Key Vault.

> ![Enable Transparent Data Encryption BYOK](./media/image168.png)

### Task 3: Scale Up Database Performance

When our database was migrated, only a Standard S0, 10 DTUs, 250 GB database was provisioned, the minimum DTUs for a Standard subscription. We need to scale out our database to at least 100 DTUs or Standard S3: 100 DTUs, 250 GB database configuration. In the blade for your database, click on the **Configure** section and slide the DTU slider to 100, then click **Apply**.

> ![Scale database performance](./media/image169.png)

### Task 4: Configure Firewall and virtual networks

Under the **Security** blade, navigate to **Firewalls and virtual networks.** We want to seal off any access from anyone except us. To allow access to Azure services, click on **ON**.

> ![Configure Firewall and virtual networks](./media/image170.png)

### Task 5: Threat Detection and Vulnerability Assessment

We want to help protect our database sever again threats. This service includes Threat Detection, Data Discovery & Classification, and Vulnerability Assessment. There is a small fee per server/month to run this service. Enable these settings by navigating to the Security section in the SQL Server blade and select **Advanced Threat Protection**.

In the storage details section, select the same storage account used for the web application.

**Note**: For performance purposes, consider using a different storage account in the same region as the database, but different from other services.

> ![Enabled advanced threat detection](./media/image171.png)

### Task 6: Turn on SQL Server Auditing

Navigate to the SQL Server. Located under the Security section, click on Auditing. In this section we will enable the SQL Server. Specify which Storage Account you want the logs to be exported too and click on **Save.**

> ![Turn on SQL Server Auditing](./media/image172.png)

### Task 7: Automatic Tuning

In the SQL Server blade, select **Support+Troubleshooting** section. Azure SQL Database has built-in intelligence to automatically tune your databases to optimize performance. At the server level, you can enable the Azure defaults. You can set the inherit state or force to be applied or off for your database. Click on **Azure defaults** and click **Apply.**

> ![Automatic Tuning](./media/image173.png)

### Task 8: Enable Database Diagnostics

If we need to troubleshoot or get a better understanding of what’s going on with our database and server, be sure to turn on the Database diagnostics. In the blade, navigate to the database you want Diagnostics turn on and click **Turn on Diagnostics**.

> ![Enable Database Diagnostics](./media/image174.png)

Next, to identify the diagnostics, type in the name. such as the name and location of the database. If you want the logs to be saved to Archived to a Storage Account, select the existing storage account. Next, toggle the retention days you want to keep each log. **Note**: you have the option to send the logs to Log Analytics or Stream to event
hub.

> ![Configure Database Diagnostics Settings](./media/image175.png)

### Task 9: Configure Long-term backup retention for database

SQL Database automatically creates database backup and uses Azure read-access geo redundant storage (RA-GRS) to provide geo redundancy. These backups are created automatically and at no additional cost. You don’t need to do anything to make it happen. SQL backup create full, differential, and transaction log backups for Point-in-time restore (PITR). The transaction log backups generally every 5-10 minutes, depending on the performance level and database activity. Logs are kept based off the DTI purchased vCore-based purchasing model. You can change the default retention using either REST API or PowerShell. The default values are 7, 14, 21, 28 or 35 days.

> ![Configure Long-term backup retention for database](./media/image176.png)

Our business requirements us to have 120 days back up, therefore, we need to configure the Long-term backup retention. Navigation to the SQL Server and under the Settings section, click on **Long-term backup retention.** Select the **PartsUnlimitedDB** from the available databases. In the Configure Policies, click **Weekly Backups**, type **120** for the length and change the drown down interval to **Days**. When done, click **Apply.**

> ![Configure database retention policies](./media/image177.png)

## Exercise 6: Optimize Entire Web Application Performance with Content Distributed Network (CDN)

**Duration**: 30 minutes

As the improvements have been rolling out to the Parts Unlimited site, marketing has been ramping up its advertising causing an uptick in traffic. While this is exactly what the company wants, it has caused some latency issues. Improvements need to be made to the Parts Unlimited site to reduce latency and improve end user experience. This must be done quickly as there are additional marketing campaigns on the horizon.

To solve the performance issues as quickly as possible, we are going to implement a Content Delivery Network for our site. It has been decided that the entire site will be cached with CDN.

- Create a CDN endpoint to Web App
- Configure for correct behavior of when using Query String
- Change for even faster performance by adding compression

With Azure CDN you have a choice of different CDN providers. Configuring the service is quick, usually around a few minutes, and billing is based on use as opposed to a
contract.

**References**

- [Azure CDN](https://azure.microsoft.com/en-us/services/cdn/)
- [CDN Overview](https://docs.microsoft.com/en-us/azure/cdn/cdn-overview)
- [Creating a new Endpoint](https://docs.microsoft.com/en-us/azure/cdn/cdn-create-new-endpoint)

### Task 1: Configure CDN for the whole web application

Using the **Networking** tab in the **Web App** blade and clicking on the **Configure Azure CDN for your app** link:

> ![App Service Networking](./media/image178.png)

Fill out the form to create a new **CDN Profile** and **CDN Endpoint** for the app:

> ![Configure Azure CDN Endpoint](./media/image179.png)

After services are created, browse the website in the edge URL to make sure it is working.

Navigate through the product categories and notice that the same page is being displayed for all categories, must be a problem with the query string parameters, let's fix that.

### Task 2: Configure Caching Rules

Click on the **CDN Endpoint** in the portal and then on the **Caching Rules** property to see what is available. We can see there is a global rule for **Query String caching behavior**, which is set to be ignored. To fix the problem, change it to **Cache every unique URL**.

> ![Azure CDN Caching Rules](./media/image180.png) 

Next, under the custom caching rules, set up a new rule to exclude the shopping cart. For the Match Condition, choose **Url Path,** Matching Value(s), type **/Shopping Cart**, and **Caching Behavior,** choose **Bypass Cache.** When you’re done, click **Save**.

Now browse the website on the edge URL and do a fresh reload on the category product pages and the problem should be fixed now, any subsequent visits will be faster because data is cached in the CDN for all pages.

### Task 3: Improve performance by adding compression

We can improve the CDN performance even further with compression rules for some types of files, specially text. Click on the **Compression** property, enable it, and click **Save**, additional MIME types can be added if desired:

> ![Azure CDN Compression](./media/image181.png)

Now browse the website after these changes and load time should be faster\!

Custom CDN usage could be added only for portions of the site if this approach is not desirable. In addition, custom domain and SSL certificates can be added to an CDN endpoint.

## Exercise 7: Optimize Partial Web Application Performance with Content Distributed Network (CDN)

**Duration**: 45 minutes

In the previous CDN exercise, we showed how you can turn on CDN for the whole entire site. However, for some sites with special content such as large files (e.g. large documents, video, etc.), we may want to optimize the delivery for that specific type of content. This lab will show you how to take a directory where your content in stored offload that content to a CDN.

- Create Resource Group & Storage Account
- Create a CDN Profile
- Create a CDN Endpoint
- Publish Content: Copy images to storage account
- Change code to use CDN
- Explore additional features

### Task 1: Create a Resource Group & Storage Account

**Note:** If you already created a Storage Group for the web app logs, you can skip this step. If you already created a CDN Profile in the previous lab, you can also skip this step and go to **Add CDN Endpoint**.

Create a resource group called CDN to place all the resources to be used for the Content Delivery Network. In the Azure Portal, click to add a resource and look for Storage Account:

> ![Create storage account](./media/image182.png)

Click on the create button to start:

> ![Create storage account](./media/image183.png)

Enter a name for the storage account, select resource manager for
deployment model & storage V2 for kind, select standard performance and
LRS for replication, Hot for tier and disabled for secure transfer
required and select the resource group where to create:

> ![Configure storage account settings](./media/image184.png)

### Task 2: Provision

In the Azure Portal, click to add a resource and select the "Web + Mobile" area and "CDN" should be immediately available:

> ![Create Azure CDN](./media/image185.png)

Enter a name for the profile, select a resource group and a pricing tier:

> ![Create Azure CDN](./media/image186.png)

### Task 3: Add a CDN Endpoint

After the CDN profile is created, you should be able to see the CDN resource and click on the **Add Endpoint** link:

> ![Create Azure CDN Endpoint](./media/image187.png)

In the dropdown, notice the available options for **Optimized for**…. Enter "{web-host}-images" name for the endpoint, select Storage as origin and click on Add:

> ![Create Azure CDN Endpoint on Storage Account](./media/image188.png)

### Task 4: Copy images to storage account

Use the Azure Storage Explorer in the Portal or [download it](https://azure.microsoft.com/en-us/features/storage-explorer/) to connect to the storage account previously created:

> ![Open Storage Account in Storage Explorer](./media/image189.png)

After authenticating and locating the storage account in the Storage Explorer, create an **images** Blob container:

If you’re using the Portal’s Storage explorer, Set the permission to "Public read access for blobs only" to allow them to be accessible.

> ![Create images container](./media/image190.png)

If you’re using the Microsoft Azure Storage Explorer for Windows:

> ![Create images container](./media/image191.png)

Change the "Public Access Level" for the "images" container:

> ![Set container access level to public](./media/image192.png)

Set the permission to "Public read access for blobs only" to allow them to be accessible:

> ![Set container access level to Public read access for blobs only](./media/image193.png)

Then proceed to copy all the files in the "/images" folder inside of the PartsUnlimitedWebsite

> ![Upload files to images container](./media/image194.png)

You can test now by requesting in a browser the URL of the endpoint + /./ + any of the file names and the image should be displayed:

> ![Test CDN for images](./media/image195.png)

### Task 5: Integrate into web application

We now need to add an Application Setting to use as source for the images, say we call it CDNUrl, add it to the web.config file with no value:

> ![Add a CDNUrl app setting](./media/image196.png)

Adding it without value will ensure the changes we are introducing do not change the behavior of the application. Now to make it easier to use, we already have a **ConfigurationHelpers** class in the project, so we can add the **PartsUnlimited.Utils** namespace in the **Views/web.config** file to make it easier to use in our views. This will shorten using this class in all places where we need it.

> ![Add PartsUnlimited.Utils namespace to view/web.config](./media/image197.png)

Now let's find the views that need to use the CDN for images, say we only concentrate on the product images, so find the pattern **./@** in the **PartsUnlimitedWebsite** project:

> ![Find usage of images in solution](./media/image198.png)

We can see in the results that 3 of the files are related to showing product images, we need to change those to use the **CDNUrl** setting, the quickest way would be to simply using the **ConfigurationHelpers.GetString** method, like the following screenshot shows in the **Views/Store/Details.cshtml** file:

> ![Add use of CDNUrl setting for all images](./media/image199.png)

Add the @**ConfigurationHelpers.GetString("CDNUrl")** to all 3 files and test the application to make sure all images are still displayed correctly.

Now add the value of the **CDNUrl** application setting using the name of the endpoint from the Azure Portal:

> ![Add value of CDNUrl](./media/image195.png)

Now test the application with the product images being served via CDN.

At this point the product images could be removed from the project or marked with build action to **None** and avoid them being included in the build artifacts.

The deployment of the images to the storage account could also be automated using:

**CLI**  
az storage blob
upload-batch

**PowerShell**

Set-AzureStorageBlobContent

[https://docs.microsoft.com/en-us/powershell/module/azure.storage/Set-AzureStorageBlobContent?view=azurermps-5.3.0](https://docs.microsoft.com/en-us/powershell/module/azure.storage/Set-AzureStorageBlobContent?view=azurermps-5.3.0)

Add a comment to your change set and commit/sync your changes, which will start a CI/CD.

> ![Commit changes](./media/image200.png)

### Task 6: Explore Enhancements

- Restrict access by country
- Compression
- Caching rules
- Purge

## Exercise 8: Increase Application / Database Performance with Redis Cache

**Duration**: 60 minutes

It has come to the businesses attention that customers are experiencing slow.

- Provision the Azure Redis service
- Improve session state by using Redis as Session State Provider
- Speed up output by using Redis as Output Cache Provider
- Reduce database usage by using Redis as Data Cache

**References**

- [Redis Cache Quick Start](https://docs.microsoft.com/en-us/azure/redis-cache/cache-dotnet-how-to-use-azure-redis-cache)
- [No Cache Anti Pattern](https://docs.microsoft.com/en-us/azure/architecture/antipatterns/no-caching/)

### Task 1: Provisioning the Redis Cache Service

Create a new Redis Cache service to use with the Parts Unlimited Website. Click to create a new resource and search for **Redis Cache**, once found highlight and click on the **Create** button:

![Provision Azure Redis Cache](./media/image201.png)

Provide the values to create the service, provide name (use your web application name), resource group, and choose the same region where your web application is located. Select "Standard C0" for pricing tier and click **Create**.

Notice the differences in the pricing tier, networking features, clustering capabilities, size, SLA, connectivity limits, etc.

> ![Configure Redis Cache Pricing Tier](./media/image202.png)

Navigate to the resource and click on the **Access Keys** property to get the primary key which we will need later to establish connectivity to the Redis Cache:

> ![Redis Cache Access Keys](./media/image203.png)

### Task 2: Improve Session Performance

Remote into the **vmdev01** using the User Name and Password used when creating the environment.

> ![Remote Desktop Connection Warning](./media/image52.png)

**Note**:

- Default Admin: sysadmin
- Default Password: Password$123

> ![Remote Desktop Credentials](./media/image11-vm-credentials.png)
>
> ![Remote Desktop Connection Certificate Warning](./media/image53.png)

Upgrade Project to target .Net Framework 4.5.2

Install the NuGet package **Microsoft.Web.RedisSessionStateProvider** in the **PartsUnlimitedWebsite** project. Notice the latest version does not work the .Net Framework version of this project, so you must choose version **3.0.2**

Modify the **Web.config** to add a new connection string replacing the
\[SERVER\_NAME\] and \[KEY\] values.

```xml
<connectionStrings>
    <add name="RedisCacheConnectionString" connectionString="[SERVER_NAME].redis.cache.windows.net:6380,password=[KEY],ssl=True,abortConnect=False" />
</connectionStrings>
```

You will notice a **sessionState** section is added in the **Web.config** file, within the **system.web** element. Replace it with the following which uses that connection string:

```xml
<sessionState mode="Custom" customProvider="MySessionStateStore">
    <providers>
        <add type = "Microsoft.Web.Redis.RedisSessionStateProvider"
            name = "MySessionStateStore"
            connectionString = "RedisCacheConnectionString" />
    </providers>
</sessionState>
```

**Note**: Use the connection string method to be able to be able to change the values at runtime without deploying your code.

After the changes, run locally to verify everything has been configured correctly by simply navigate to the Shopping Cart on the website, add a few items to the cart, then check the statistics on the Redis Cache:

> ![Azure Redis Cache](./media/image204.png)

To prove this works, scale out to 2 instances, repeat adding some products to the cart. Scale down and keep doing the same actions on the site and everything should work without any data being lost.

### Task 4: Speed Up Output and Reduce Memory Footprint

The next thing we want to do is reduce the memory footprint and speed up the output when customers browse the store front. While we have some performance gains by adding a CDN across the site, we also can make further improvements by making some minor changes to our code based specific to the store.

Install the NuGet package **Microsoft.Web.RedisOutputCacheProvider** in the **PartsUnlimitedWebsite** project.

Second, add the following section in the **Web.config** file, within the
**system.web** element:

You will notice a **sessionState** section is added in the **Web.config** file, within the **system.web** element. Replace it with the following which uses that connection string:

```xml
<outputCache defaultProvider="MyStoreRedisOutputCache">
    <providers>
        <add type = "Microsoft.Web.Redis.RedisOutputCacheProvider"
            name = "MyStoreRedisOutputCache"
            connectionString = "RedisCacheConnectionString" />
    </providers>
</outputCache>
```

**Note**: Use the connection string method to be able to be able to change the values at runtime without deploying your code.

Third, modify the **Controllers\\StoreController.cs** file to add the following attributes in the Browse and Details functions:

```csharp
[OutputCache(Duration = 30, VaryByParam = "*")]
public ActionResult Browse(int categoryId) {
    ...
}

[OutputCache(Duration = 30, VaryByParam = "id")]
public ActionResult Details(int id){
    ...
}
```

Notice the first one will cache the output taking into accounts all the parameters, the second one will do it only for the id parameter.

You can verify by adding a breakpoint inside the methods and visiting a product in the website, the first time you visit the page the code will hit the breakpoint, subsequent visits to the page will not.

### Task 5: Reducing database utilization

This next section, we will demonstrate how to reduce the amount of database utilization by using Redis as a custom caching provider. This will require some custom code.

If not already installed, install the NuGet package **StackExchange.Redis.StrongName** in the **PartsUnlimitedWebsite** project.

Right-Click on the PartsUnlintedWebSite project name in Solution Explorer. Select **Manage NuGet Packages…** from the available options.
From the NuGet Manager screen on the Browse tab, search for **StackExchange.Redis.StrongName** and **Install** the latest version.

Create a new C\# file in the **Utils** folder called **RedisHelper.cs** and copy the contents below into that new file.

```csharp
using Newtonsoft.Json;
using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace PartsUnlimited.Utils
{
    static class RedisHelper
    {
        private static JsonSerializerSettings serializerSettings;

        static RedisHelper()
        {
            serializerSettings = new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            };
        }

        private static Lazy<ConnectionMultiplexer> lazyConnection = new Lazy<ConnectionMultiplexer>(() =>
        {
            string connectionString = ConfigurationManager.ConnectionStrings["RedisCacheConnectionString"].ConnectionString;

            return ConnectionMultiplexer.Connect(connectionString);
        });

        public static ConnectionMultiplexer Connection
        {
            get
            {
                return lazyConnection.Value;
            }
        }

        public static T Get<T>(string key)
        {
            var r = Connection.GetDatabase().StringGet(key);
            return Deserialize<T>(r);
        }

        public static List<T> GetList<T>(string key)
        {
            return Get<List<T>>(key);
        }

        public static void SetList<T>(string key, List<T> list)
        {
            Set(key, list);
        }

        public static void Set(string key, object value)
        {
            Connection.GetDatabase().StringSet(key, Serialize(value));
        }

        static string Serialize(object o)
        {
            if (o == null)
            {
                return null;
            }

            return JsonConvert.SerializeObject(o, serializerSettings);
        }

        static T Deserialize<T>(string value)
        {
            if (value == null)
            {
                return default(T);
            }

            return JsonConvert.DeserializeObject<T>(value, serializerSettings);
        }
    }
}
```

**Note**: The system assembly also needs to be referenced, add “using System;” before the namespace.

```csharp
using System;
namespace PartsUnlimited.Models
{
    [Serializable]
    public class Category
    {
        ...
    }
}
```

Modify the **HomeController.cs** to use Redis instead of the MemoryCache:

```csharp
public ActionResult Index()
{
    // Get most popular products
    var topSellingProducts = Utils.RedisHelper.GetList<Product>("topselling");
    if (topSellingProducts == null)
    {
        topSellingProducts = GetTopSellingProducts(4);
        Utils.RedisHelper.SetList("topselling", topSellingProducts);
    }

    var newProducts = Utils.RedisHelper.GetList<Product>("newarrivals");
    if (newProducts == null)
    {
        newProducts = GetNewProducts(4);
        Utils.RedisHelper.SetList("newarrivals", newProducts);
    }

    var viewModel = new HomeViewModel
    {
        NewProducts = newProducts,
        TopSellingProducts = topSellingProducts,
        CommunityPosts = GetCommunityPosts()
    };

    return View(viewModel);
}
```

Validate our changes by adding a breakpoint on the first line of the Index() function in the HomeController.cs and run the website locally. A call to the **GetTopSellingProducts** and **GetNewProducts** should be made only the first time the page loads.

If everything works as expected, then comment and commit/sync your code into Azure DevOps.

## Exercise 9: Improve Quality & Performance of Search with Azure Search

**Duration**: 30 minutes

It has come to the businesses attention that customers are not able to find what they are looking for easily. After some investigation it was determined that the existing search capabilities were not adequate and needed to be updated. To improve the application’s search capability as quickly as possible, with as little code as possible, while ensuring the ability to support the sites growing traffic, Azure Search will be implemented.

- Go to the Azure Portal
- Look at the Parts Unlimited DB config
- Add Azure Search
- Create a branch
- Modify the application to use Azure Search
- Test Local
- Commit and push to release
- Test in production

**References**

- [Azure Search](https://docs.microsoft.com/en-us/azure/search/)

### Task 1: Create Azure Search Service

Current search is based on SQL queries and prone to bad results. Doing a search like "jumper" or "leads" will return a product match like the following:

> ![Parts Unlimited Search](./media/image205.png)

Clicking on the Product, we can see a lot more text that could be searched for:

> ![Product Description](./media/image206.png)

But doing a search on text within the Product's description or details, like "corrosion" would not return any matches:

> ![Search does not match description](./media/image207.png)

In the Azure Portal, create a new instance of **Azure Search**:

> ![Provision Azure Search](./media/image208.png)

Enter the **name** and **resource group** for the service and click create:

> ![Provision Azure Search](./media/image209.png)

### Task 2: Import Data in Azure Search

After the service is created, we must proceed to create an index and populate it with data. To start this process, we will take advantage of the existing database and use the **Import Data** wizard:

> ![Import Data in Azure Search](./media/image210.png)

Provide the details for a data source, selecting the type of source, in our case **Azure SQL Database** and providing the connection string values and selecting the **Table/View** of **Products**: For the name, since this is a unique value, type in the host name associated with the application. After typing the name, select the partsUnlimitedDB for the database, UserId, and Password, click on **Test connection** in order to verify the credentials are correct.

**Note**: Use the same name for the database that you used when you created the environment. Note, you may also need to change the login to \[username\]@hostname.

- Database User: sysadmin
- Database Password: Password$123

> ![Add data source](./media/image211.png)

Configure the index, name it **products-index**, select all fields to be retrievable and select as *searchable* **Title**, **Description** and **ProductDetails**:

> ![Configure index](./media/image212.png)

Define the indexer property to update the data in the index, in this case we will select **Once** and click **Ok**. To setup recurring indexer we would need a field to use to track changes, which we don't have now, but adding a field like **UpdatedDate** that is updated every time the product fields are updated would work.

> ![Configure indexer](./media/image213.png)

Clicking Ok on the Import Data blade after all details are provided would trigger the indexer to run and it should look like the screenshot below indicating all documents have been indexed.

> ![Check indexer status](./media/image214.png)

### Task 3: Integrate search into application

Remote into the **vmdev01** using the User Name and Password used when creating the environment.

Upgrade the **PartsUnlimitedWebsite** project to target at least the **.Net Framework 4.5.2** to be able to use the Azure Search SDK. This is done via the properties page of the project.

You must add the NuGet package **Microsoft.Azure.Search** that will enable us to code against the Azure Search service. This can be done from the Package Manager Console with the following command:

*Install-Package Microsoft.Azure.Search*

Add some entries in the **Web.config** that will be used to setup the values for integrating with the Azure Search service. The value for the **SearchServiceQueryApiKey** is obtained from the **Azure Search Service/Keys/Manage Search Query** blade.

> ![Azure Search Keys](./media/image215.png)
>
> ![Azure Search Query Keys](./media/image216.png)

```xml
<add key="SearchServiceName" value="partsunlimited" />
<add key="SearchServiceQueryApiKey" value="*************" />
<add key="SearchServiceIndexName" value="products-index" />
```

Add a new class called **AzureIndexProductSearch** in the **ProductSearch** directory:

```csharp
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Microsoft.Azure.Search;
using Microsoft.Azure.Search.Models;
using PartsUnlimited.Models;

namespace PartsUnlimited.ProductSearch
{
    public class AzureIndexProductSearch : IProductSearch
    {
        public async Task<IEnumerable<Product>> Search(string query)
        {
            List<Product> products = new List<Product>();

            try
            {
                DocumentSearchResult<Product> searchResults;

                var parameters = new SearchParameters()
                {
                    Select = new[] { "ProductId", "SkuNumber", "CategoryId", "Title", "Price", "SalePrice", "ProductArtUrl", "Description", "ProductDetails", "Inventory", "LeadTime" }
                };

                using (var searchClient = CreateSearchIndexClient())
                {
                    searchResults = await searchClient.Documents.SearchAsync<Product>(query, parameters);
                }

                foreach (var r in searchResults.Results)
                {
                    products.Add(r.Document);
                }
            }
            catch (Exception)
            {
                // Throw exception for easier troubleshooting
                throw;
            }

            return products;
        }

        private static SearchIndexClient CreateSearchIndexClient()
        {
            string searchServiceName = ConfigurationManager.AppSettings["SearchServiceName"];
            string queryApiKey = ConfigurationManager.AppSettings["SearchServiceQueryApiKey"];
            string indexName = ConfigurationManager.AppSettings["SearchServiceIndexName"];

            return new SearchIndexClient(searchServiceName, indexName, new SearchCredentials(queryApiKey));
        }

    }
}
```

Replace the class used for the search in the **UnityConfig.cs** file in the **App\_Start** directory:

Replace:

```csharp
container.RegisterType<IProductSearch, StringContainsProductSearch>();
```

With:

```csharp
container.RegisterType<IProductSearch, AzureIndexProductSearch>();
```

### Task 4: Verify Search Results

Running the application should allow us to perform the same search as before for "jumper" or "leads" and obtain the same results. However, it is possible now to obtain results by searching by the word "corrosion" and getting as expected the Product with that text in the Description:

> ![Verify Search Results](./media/image217.png)

### Task 5: Commit & Sync Code

When you’re all done verifying the search is working on your local machine, comment, commit, and sync your code. This will kick off the CI/CD. Once Azure DevOps Release Management deploys the code, perform a spot check to verify the changes you’ve made to the search is showing up.

## Exercise 10: Accelerate development and take advantage of serverless using Azure Functions

**Duration**: 45 minutes

Parts Unlimited has been growing. The business wants to start building relationships with other retailers, so they can sell their product through multiple channels, not just Parts Unlimited.

To get started, the Parts Unlimited site needs to be improved architecturally so portions of its functionality can be reused when integrating with third parties. To accomplish this, the products model will be split into a reusable class. Functions will then be built using this class. Next, the Parts Unlimited website will be modified to use the Azure functions as opposed to accessing the database directly.

**References**

- [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/)
- [Creating a Function through the Azure Portal](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function)

### Task 1: Refactor

Add a new **PartsUnlimitedModels** Class Library (.Net Framework) project to the Visual Studio solution to move all models classes, make sure to select **.Net Framework 4.5.2**:

> ![Add new project](./media/image218.png)
>
> ![Select Class Library (.NET Framework)](./media/image219.png)

Add the following NuGet packages to the project (Managing NuGet packages in the solution is the fastest way to do this) using the Solution NuGet Package Management option to match the existing versions:

- EntityFramework
- Owin
- Microsoft.Owin
- Microsoft.AspNet.Identity.Owin
- Microsoft.AspNet.Identity.EntityFramework
- Microsoft.AspNet.Mvc

Add an assembly reference to **System.Web**

> ![Adding System.Web reference](./media/image220.png)

Move the **Models** directory and all files within it to the **PartsUnlimitedModels** project:

> ![PartsUnlimitedModels Project](./media/image221.png)

Add a project reference in **PartsUnlimitedWebsite** to **PartsUnlimitedModels** and make sure it still builds successfully:

> ![Add PartsUnlimitedModels Project Reference](./media/image222.png)
>
> ![Add PartsUnlimitedModels Project Reference](./media/image223.png)

Build and run the solution to ensure everything compiles and runs okay.

### Task 2: Modernize

Add a new **Azure Functions** project to the solution called **PartsUnlimitedStoreService** using the **Cloud** templates:

> ![Add new Azure Functions Project](./media/image224.png)

When creating a new Azure Functions project, make sure to change the framework to “Azure Functions v1 (.NET Framework), then click **OK** to continue.

> ![Add new Azure Functions Project](./media/image225.png)

**Note**: Make sure the **PartsUnlimitedModels** and **PartsUnlimitedStoreService** projects are both running the same .NET framework version

After the project is created, we’ll create three new Functions. The 3 functions in the Function App: **BrowseCategory**, **GetCategories** & **GetProductDetails** to provide the functionality currently available in the **StoreController** in the **PartsUnlimitedWebsite** project. They should be accessed via URLs in the form **"/api/categories"**, **"/api/categories/{id}"** & **"/api/products/{id}"** respectively.

> ![Add Class](./media/image226.png)

Right click on the new **PartsUnlimitedStoreService** project, choose **Add**, **New Azure Function**.

> ![New Azure Function](./media/image227.png)

Select the **Http trigger** and the Access Rights as **Function**.

> ![New Azure Function](./media/image228.png)

Next, make a reference to our **PartsUnlimitedModels** project:

> ![Add reference to PartsUnlimitedModels Project](./media/image229.png)

Add a reference to the same version of the **EntityFramework** that you’re using in the web project. In the Solution Explorer, right-click on dependencies and select **Manage NuGet Package.** Click the **Browse** tab and search for EntityFramework.

Notice that for this to work, we will need the connection string to the database available for the Function App to work, which locally can be set in the **local.settings.json** file:

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "AzureWebJobsDashboard": "UseDevelopmentStorage=true"
  },
  "ConnectionStrings": {
    "DefaultConnectionString": "Server=(localdb)\\mssqllocaldb;Database=PartsUnlimitedWebsite;Integrated Security=True;"
  }
}
```

Create a new class called **GlobalConfiguration.cs** and replace its contents with the snippet below:

**GlobalConfiguration.cs**

```csharp
using System.Net.Http;
using System.Web.Http;

namespace PartsUnlimitedStoreService
{
    internal static class GlobalConfiguration
    {
        internal static void SetConfiguration(HttpRequestMessage req)
        {
            HttpConfiguration config = req.GetConfiguration();

            config.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
        }
    }
}
```

Replaces the contents of the GetCategories.cs from below.

Create a new class called **GetCategories.cs** and replace its contents with the snippet below:

**GetCategories.cs**

```csharp
using System.Data.Entity;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using PartsUnlimited.Models;

namespace PartsUnlimitedStoreService
{
    public static class GetCategories
    {
        [FunctionName("GetCategories")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Function, "get", Route = "categories")]HttpRequestMessage req, TraceWriter log)
        {
            GlobalConfiguration.SetConfiguration(req);

            log.Info("Retrieving Product Categories");

            var db = new PartsUnlimitedContext();
            var categories = await db.Categories.ToListAsync();

            return req.CreateResponse(HttpStatusCode.OK, categories);
        }
    }
}
```

Create a new class called **BrowseCategory.cs** and replace its contents with the snippet below:

**BrowseCategory.cs**

```csharp
using System.Data.Entity;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using PartsUnlimited.Models;

namespace PartsUnlimitedStoreService
{
    public static class BrowseCategory
    {
        [FunctionName("BrowseCategory")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Function, "get", Route = "categories/{id:int}")]HttpRequestMessage req, int? id, TraceWriter log)
        {
            GlobalConfiguration.SetConfiguration(req);

            log.Info($"Get Product Category {id}");

            if (!id.HasValue)
                return req.CreateResponse(HttpStatusCode.BadRequest, "Please pass a valid category ID");

            var db = new PartsUnlimitedContext();
            var genreModel = await db.Categories.Include("Products").SingleAsync(g => g.CategoryId == id.Value);

            return req.CreateResponse(HttpStatusCode.OK, genreModel);
        }
    }
}
```

Create a new class called **GetProductDetails.cs** and replace its contents with the snippet below:

**GetProductDetails.cs**

```csharp
using System.Data.Entity;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using PartsUnlimited.Models;

namespace PartsUnlimitedStoreService
{
    public static class GetProductDetails
    {
        [FunctionName("GetProductDetails")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Function, "get", Route = "product/{id:int}")]HttpRequestMessage req, int? id, TraceWriter log)
        {
            GlobalConfiguration.SetConfiguration(req);

            log.Info($"GetProductDetails {id}");

            if (!id.HasValue)
                return req.CreateResponse(HttpStatusCode.BadRequest, "Please pass a valid product id");

            var db = new PartsUnlimitedContext();
            var product = await db.Products.SingleAsync(a => a.ProductId == id.Value);

            return req.CreateResponse(HttpStatusCode.OK, product);
        }
    }
}
```

The function can now be tested locally using an Http Client like Postman or any other of your choice. To test, right-click on **PartsUnlimitedStoreService** as click on **Set as Startup Project**.

> ![Set PartsUnlimitedStoreService as startup project](./media/image230.png)

If prompted to install the Azure Function CLI tools, click **Yes**.

> ![Azure CLI Installation Confirmation](./media/image231.png)

After a moment, you’ll see a command window appear running func.exe. Note the URLs

> ![Azure CLI Console](./media/image232.png)

Run Postman from the Desktop and issue a GET against the **GetCategories** /api/GetCategories

> ![Use Postman to test](./media/image233.png)

### Task 3: Integrate

Replace the code in **StoreController.cs** in the **PartsUnlimitedWebsite** project to retrieve data from the Function App by making a REST call to the appropriate endpoint.

**Tip**: Using a utility class like **System.Net.Http.HttpClient** makes it easy to implement the calls and writing a generic method convenient for reusability.

The URL of the Function App should be defined in the **Web.config** to easily change it during deployment and if a key is to be used for access control should be also in configuration. Add the following two lines to the ```<appSettings/>``` section, replacing the value of the StoreServiceBaseAddress with your local instance.

```xml
<add key="StoreServiceBaseAddress" value="http://localhost:7071/api/" />
<add key="StoreServiceKey" value="" />
```

Next add to the bottom of the **StoreController.cs** method:

```csharp
private static async Task<T> GetFromStoreService<T>(string path)
{
    //specify to use TLS 1.2 as default connection
    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

    using (var client = new HttpClient())
    {
        var baseAddress = ConfigurationManager.AppSettings["StoreServiceBaseAddress"];
        var key = ConfigurationManager.AppSettings["StoreServiceKey"];

        client.DefaultRequestHeaders.Accept.Clear();
        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

        if (!string.IsNullOrWhiteSpace(key))
        {
            client.DefaultRequestHeaders.Add("x-functions-key", key);
        }

        var uri = new Uri(baseAddress + path);

        HttpResponseMessage response = await client.GetAsync(uri);
        return await response.Content.ReadAsAsync<T>();
    }
}
```

Add the **System.Threading.Tasks**, **System.Collections.Generic, System.Net.Http, and System.Net.Http.Headers**, **System.Net**; reference to the top of the class. Then replace the Intex(), Browse(int), Details(int) methods with the ones below. Notice the public methods in the class can be implemented in an asynchronous way and simpler:

```csharp
using PartsUnlimited.Models;
using System;
using System.Runtime.Caching;
using System.Web.Mvc;
using PartsUnlimited.Utils;
using PartsUnlimited.ViewModels;
using System.Net.Http;
using System.Configuration;
using System.Net.Http.Headers;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Net;

namespace PartsUnlimited.Controllers
{
    public class StoreController : Controller
    {

    …

        // GET: /Store/
        public async Task<ActionResult> Index()
        {
            return View(await GetFromStoreService<List<Category>>("categories"));
        }

        //
        // GET: /Store/Browse?genre=Disco
        public async Task<ActionResult> Browse(int categoryId)
        {
            return View(await GetFromStoreService<Category>($"categories/{categoryId}"));
        }

        public async Task<ActionResult> Details(int id)
        {
            var productCacheKey = string.Format("product_{0}", id);
            var product = MemoryCache.Default[productCacheKey] as Product;
            if (product == null)
            {
                product = await GetFromStoreService<Product>($"product/{id}");
                //Remove it from cache if not retrieved in last 10 minutes
                MemoryCache.Default.Add(productCacheKey, product, new CacheItemPolicy { SlidingExpiration = TimeSpan.FromMinutes(10) });
            }

            var viewModel = new ProductViewModel
            {
                Product = product,
                ShowRecommendations = ConfigurationHelpers.GetBool("ShowRecommendations")
            };

            return View(viewModel);
        }
    }
}
```

Test locally and ensure everything works as expected and no functionality has been affected from the website standpoint.

In Solution Explorer, right-click on the Solution and click **Set Startup Projects**. Select Multiple startup projects and for the action for **PartsUnlimitedStoreService** and **PartsUnlimitedWebsite**, choose **Start**.

Browse the product categories and details of the site and notice the Functions getting executed.

> ![Console output](./media/image234.png)

### Task 4: Publish the Service

Now that we have a working Function App with the website, it is time to deploy to Azure, which can be accomplished using the Publish feature in Visual Studio. 

> ![Publish Project](./media/image237.png)

Select the **Function App** target and **Create new** option:

> ![Publish to Azure Function App](./media/image238.png)

Enter or select the appropriate values for the publish profile, selecting the Consumption for the hosting plan and your existing Storage Account used for the website. You can also choose your existing website to host the Functions.

> ![Function App Configuration](./media/image239.png)

Decide how this function will be hosted. It will either use a Consumption Plan, where Microsoft manages the scaling up/down the infrastructure to support your Function or an existing App Plan to take advantage of infrastructure you’ve already defined. Select your existing Storage Account where you’re storing the Application Log files. After everything is configured, click **Create** to continue.

> ![Configure Hosting Plan](./media/image240.png)

In a few moments, the new environment will be configured and the deployment to that will begin.

> ![Publish Dialog](./media/image241.png)

### Task 5: Configure Function Database Connection

Once the Function is complete, using the Azure Portal, navigate to the newly created Function **App Service**. Notice the Function Icon.

> ![Azure Function App Resource](./media/image242.png)

You can navigation to the URL for the Function App to verify the Function has been provisioned correctly.

> ![Function App Settings](./media/image243.png)
>
> ![Verify Function App Running](./media/image244.png)

After publishing the Function App, we need to add the required Connection String for the database, which can be done via the Azure portal:

> ![Add Database Connection String to Azure Function App](./media/image245.png)

After publishing is completed, publish a new version of the website including the Application Settings for the location and key of the Store Service and test.

### Task 5: Configure Function Application Insights

> ![Add Application Insights to Azure Function App](./media/image246.png)

Click **Configure**.

> ![Configure Application Insights](./media/image247.png)

Next, you have a choice to create a new Application Insights instance or select your existing resource. Since we want to see everything in area, we’ll select our existing application and click **OK.** After configuring Application Insights, notice the Live Stream is now available.

> ![Application Insights Metrics](./media/image248.png)

Use Postman to verify that everything the function can communicate with the database and Application Insights in configured correctly.

In Postman, send a Get to the Function Service using the URL <https://[service_name].azurewebsites.net/api/categories> and ensure the payload coming back is the json results.

> ![Test in Postman](./media/image249.png)

Instead of configuring our web application to use the Function directly, in our next Exercise, we’ll configure our website to go through API Management instead.

### Task 6: Modify App Service CI/CD Task

The solution file will now produce artifacts for the web application, **PartsUnlimitedWebsite.zip**, and one for the store, **PartsUnlimitedStoreService.zip**. Our current build task will fail since it can’t deploy multiple ZIP files to the service, therefore, we need to specify the correct file. Navigate to your Azure DevOps instance, to Releases, and modify the App Service deployment task to have the correct file.

> ![Fix CI/CD release pipeline](./media/image250.png)

## Exercise 11: Monetize your data and services, and open new channels to customers using Azure API Management

**Duration**: 45 minutes

Now that Parts Unlimited has an API available, the business wants to start building relationships with other retailers, so they can sell their product through multiple channels. We’ve decided to use Azure API Management to expose and manage our
API.

**References**

- [API Management](https://docs.microsoft.com/en-us/azure/api-management/)

### Task 1: Create Azure API Management

Since the creation of the Azure API Management takes a little bit to provision, we will configure it now. In the Azure Portal, create a new instance of API Management:

> ![API Management in the Azure Marketplace](./media/image46.png)

Type in the name (e.g. use the same name as your web application), choose the region that’s the same as the web application that is already deployed, then type in the organization name, and then type your email address. When you’re all done, click **Create.** Provisioning this resource can take up to 1 hour.

> ![Create API Management Resource](./media/image47.png)

### Task 2: Set up new a new API in the Azure Portal

To create a new API in Azure API Management, we will use the OpenAPI definition (Swagger) from our web application.

Add a new API using the Azure Portal:

> ![API Management](./media/image251.png)
>
> ![Add new API](./media/image252.png)

Click **Browse** to select the new function to Add.

> ![Add Function App](./media/image253.png)

To add an OpenAPI definition, go to the Function App and use the Platform Features tab to add an API definition:

> ![Generate API Definition](./media/image254.png)

It might fail at first:

> ![Generate API Definition](./media/image255.png)

Click on the **Generate API definition template** button to generate it from code and then click the **Save** button:

> ![Generate API Definition](./media/image256.png)

The auto generated API definition is not complete and contains a few placeholders that should be edited manually, for simplicity use **-application/json** as value for the **produces** and **consumes** attributes, add descriptions and remove the security related attributes.

Now add the API to API Management as attempted before and the error should not be present anymore, make sure to only add the **Unlimited** product:

> ![Add API](./media/image257.png)

After your selections, click **Create**.

You can now test each of the methods of API in API Management, like the following test with get categories:

> ![Test API](./media/image258.png)
>
> ![Test API](./media/image259.png)

Update the web project GetFromStoreService method to pass the StoreServiceKey value in the HTTP header request. Change the StoreServiceBaseAddress in the AppSetting section of the **Web.Config**.

Run the project locally and if everything works, then commit and push your code to the repository. After the build has complete.

### Task 3: Enable Application Insights

Now that the API is set, we want to further monitor application performance and be able to easily trace down exceptions when this occurs. Configure Application Insights by navigating to the Application Insights (preview). In the stop, **Select Application Insights** and pick the web application subscription. This will mark settings as **Enabled** and automatically insert the instrumentation key, click on **Save**.

> ![Enable Application Insights](./media/image260.png)

After the site has been deployed, explore the live site. Navigate back to the Azure Portal and explore Application Insight. Look at the different dependencies being called Database, Function, and API Management.

### Task 4: Explore the API Management (APIM) Developer Portal

From the APIM resource in the Azure Portal, click on the link to the Developer Portal:

> ![API Management Developer Portal](./media/image261.png)

Here you can sign up for access to the API, browse through API definitions and test them, check the products and applications available.

Here you will also have the possibility to customize styles for the look and feel of the developer portal:

> ![API Management Developer Portal Customization](./media/image262.png)

## After the hands-on workshop

**Duration:** 10 minutes

In this exercise, attendees will deprovision any Azure resources that
were created in support of the
lab.

**Delete the Resource Group in which you placed your Azure resources.**

1. From the Portal, navigate to the blade of your Resource Group and click Delete in the command bar at the top
2. Confirm the deletion by re-typing the resource group name and clicking Delete

You should follow all steps provided *after* attending the hands-on lab.
