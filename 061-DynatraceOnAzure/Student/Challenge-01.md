# Challenge 01 - OneAgent Observability on VM

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites
- Make sure you've meet all the success criteria for Challenge 0

## Introduction


When considering migration strategies like re-hosting or re-architecting, evaluating the risks, costs, and benefits is essential. Unfortunately, the specifics of the technical stack, including what is located where and what depends on what, are often not well-documented. This lack of information may be limited to outdated diagrams and a mix of monitoring tool metrics that someone must piece together.

The lack of detailed information about the current environment makes it challenging for organizations to decide what and when to migrate.

To solve this problem, Dynatrace OneAgent can automatically identify applications, services, and processes and create a comprehensive map of dependencies for the entire application environment. Let's get started!

### Challenge Setup Diagram
Referring to the picture below:
    ![](images/challenge1-sampleapp-setup.png )
Here are the components for this challenge
#1 . Sample Application

Sample app representing a simple architecture of a frontend and backend implemented as Docker containers that we will review in this challenge.

#2 . Dynatrace monitoring

The Dynatrace OneAgent has been installed by this challenge via provisioning scripts and is communicating to your Dynatrace tenant.

#3 . Load generator process

A docker processes that sends simulated user traffic to the sample app using Jmeter run within a Docker container. You will not need to interact with this container; it just runs in the background.





## Description

Navigate through various screens of Dynatrace to understand the details of your application that Dynatrace's OneAgent automatically discovers on an Azure VM.

## Objectives of this Challenge

-  Review real-time data now available for your application that you have to migrate

-  Review how Dynatrace helps with migration or modernization planning under the tips section below

## Tasks to complete this challenge

* Navigate to the sample app running on VM
    - Get the Public IP for `dt-orders-monolith` VM from Azure Portal
    - Open up browser on your workstation and paste the IP address to navigate to the sample app
    >**Note:** Feel free to navigate around the app by using the menu on homepage to navigate around the application to pull up customer list, catalog list or order list.


* Navigate to OneAgent Deployment Status screen; from the navigation menu on the left, go to **Manage** and select **Deployment status**.  
    - Search for recently connected `dt-orders-monolith` VM to ensure its reporting in to Dynatrace UI.   

*  Navigate to host monitoring screen; from the navigation menu, go to **Infrastructure** and select **Hosts** and click on `dt-orders-monolith` host.  
    - Find host performance metrics charts for CPU, memory and network metrics for this host
    - Check to see which if you can find node.js and ApacheJmeter processes running on this host
    - Identify how many and names of containers that are running on this host
    - Identify the Azure tags applied to this host.
*  Navigate the new Infrastructure & Operations App
    - Review the DataCenters and Hosts view screens in the app.
    - Review the Host details screen for ``dt-orders-monolith`` VM such as Overview, Technologies, Process, Problems, Vulnerabilities, etc.
* Navigate to Smartscape topology screen for this; while in classic host monitoring screen click on `...` box on upper right hand corner of the host and click on `Smartscape view`.
    - Identify which 2 downstream services are used by the frontend service to  communicates with
    - Identify which Azure region (data center) your host is running in

*  Navigate to Services monitoring screen; from the navigation menu, go to **Application & Microservices** and select **Services** and click on `frontend` service
    - Identify what process technology the frontend services run in under properties & tags
    - View dynamic web requests for this service and identify top 5 requests
    - Create Multi-dimensional analysis and filter requests by any exception

* Navigate to the `frontend` service screen and click on `View Service flow`
    - Identify the two downstream services the frontend relies on?
    - Identify  the response time for `embedded database` service
    - Identify the throughput value for `backend` service 

* Navigate to the `backend` service screen and click on `Analyze backtrace`
    - Identify the service that calls the `backend` service?    

* Navigate to Databases monitoring screen; from the navigation menu, go to **Application & Microservices** and select **Databases**
    - Identify the database name and database vendor
    - Identify which specific SQL statements show up in `Current hotspots` view

* Navigate to Technologies overview screen; from the navigation menu, go to **Infrastructure** and select **Technologies and processes** screen
    - Identify  top 5 technologies that are running across all monitored applications on your Dynatrace tenant
    - Identify which 2 technologies are running on `dt-orders-monolith` host filtering on tag with `stage:production`

## Success Criteria

*  `dt-orders-monolith` VM is visible under Manage -> Deployment Status -> OneAgents screen

* You are can identify:  
    - Performance metrics charts for CPU, memory and network utilization for the host 
    -  node.js and ApacheJmeter processes running on this host 
    -  how many and names of containers that are running on this host 
    -  Azure tags applied to this host
* You have successfully identified downstream services used by frontend and Azure region of the host.

* You have successfully identified what the process technology for frontend service, identified top 5 requests web requests and created a multi-dimensional analysis view.

* You have successfully identified two downstream services the frontend service relies on, response time for embedded database service and throughput value for backend service.

* You have successfully identified the the service that calls the backend service?

* You have successfully identified the database name and database vendor and SQL statements from the hotspots view.

* You have successfully identified top 5 technologies that are running your Dynatrace tenant and 2 technologies are running on dt-orders-monolith 

## Learning Resources

- [Dynatrace OneAgent documentation](https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent)
- [Dynatrace OneAgent VM Extension](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/microsoft-azure-services/oneagent-integration/integrate-oneagent-on-azure-virtual-machines/)
- [Dynatrace Host Monitoring](https://www.dynatrace.com/support/help/how-to-use-dynatrace/hosts/monitoring/host-monitoring)
- [Dynatrace install](https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent/installation-and-operation/linux/installation/install-oneagent-on-linux#youve-arrived)
- [Dynatrace Smartscape screen](https://www.dynatrace.com/support/help/how-to-use-dynatrace/smartscape/visualize-your-environment-topology-through-smartscape)
- [Dynatrace Services screen](https://www.dynatrace.com/support/help/how-to-use-dynatrace/services)
- [Dynatrace Analyze Service Flow](https://www.dynatrace.com/support/help/how-to-use-dynatrace/services/service-flow)
- [Dynatrace Analyze Service Backtrace](https://www.dynatrace.com/support/help/how-to-use-dynatrace/services/analysis/service-backtrace)
- [Dynatrace Analyze Database Services](https://www.dynatrace.com/support/help/how-to-use-dynatrace/databases/analyze-database-services)
- [Dynatrace Technologies Screen](https://www.dynatrace.com/support/help/how-to-use-dynatrace/process-groups/monitoring/overview-of-all-technologies-running-in-my-environment )
## Tips
### OneAgent Deployment
 - Dynatrace OneAgent can be deployed in multiple ways
    - [Azure VM Extension](https://www.dynatrace.com/support/help/setup-and-configuration/setup-on-cloud-platforms/microsoft-azure-services/azure-integrations/azure-vm)
    - Dynatrace Hub (from the left side navigation, go to Manage -> Hub -> One Agent -> Download agent)
    - [Dynatrace-provided orchestration scripts for Ansible & Puppet](https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent/deployment-orchestration)
### Dynatrace Host view
- The host view shows historical and live time-series data for usage as well as the consuming processes. 
    > 👍 ``How this helps``
    > - As you plan your migration, each of these views will give insights into accessing the profile, consumption and dependencies to other systems and services..  

### Dynatrace Smartscape view
- Smartscape shows all the dependencies of a given service. This include connections to queues, web servers, app servers, and a native process. 
    > 👍 ``How this helps``
    > - As you plan your migration, this information allows us to better plan the migration, as all depending services must be considered during the migration.

### Dynatrace services view
 - Web and mobile applications are built upon services that process requests like web requests, web service calls, and messaging.
 - Dynatrace automatically detects and names server-side services of your applications based on basic properties of your application deployment and configuration. For example, in Java monitoring, Dynatrace sees your host, JVM, and processes as a whole.
    > 👍 ``How this helps`` 
    > - As you plan your migration, it is important to gain a complete picture of interdependency to the rest of the environment architecture at host, processes, services, application perspectives. 
    > - Since time is always scarce, being able to do this in a single place can shorten assessment timelines.

### Service flow diagram
- Service flow diagram illustrates the sequence of service calls that are triggered by each service request in your environment.
    > 👍 ``How this helps`` 
    > - As you plan your migration, it is important to gain a complete picture of interdependency to the rest of the environment architecture at host, processes, services, and application perspectives. 
    > - Knowing the type of access, executed statements, and amount of data transferred during regular hours of operation allows for better planning and prioritization. 

### Service Backtrace view
- The backtrace tree view represents the sequence of services that led to this service call, beginning with the page load or user action in the browser.
    > 👍 How this helps
    > - Using the service flow and service backtrace, these two tools give you a complete picture of interdependency to the rest of the environment architecture at host, processes, services, application perspectives.
### Databases view
- Dynatrace provides you with a number of ways to monitor your database performance.
    > 👍 How this helps
    > - When monitoring database activity, Dynatrace shows you which database statements are executed most often and which statements take up the most time. You can also see which services execute the database statements, what will be direct input to migration planning, and prioritization of the move groups.
    
    > - Dynatrace monitors all the popular databases like SQL Server, Oracle, and MongoDB. See Dynatrace documentation for more details on platform support.

###  Technologies view
- Technology overview page provides a consolidated overview of the health and performance of all monitored technologies in your environment. 
- This saves you the effort of browsing multiple technology-specific analysis views to get the information you need.
    > 👍 How this helps
    > - This is another out the box feature that helps you understand what technologies are in your environment with a heat map presentation that shows to what degree they exist.
    > - As you plan your migration, knowing what technologies make up your eco-system is key so that you can decide whether to migrate, refactor or replace certain services.

## Advanced Challenges (Optional)

