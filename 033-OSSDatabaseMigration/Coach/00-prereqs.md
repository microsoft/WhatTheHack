# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](./README.md)** - [Next Challenge >](./01-discovery.md)

## Coach tips

There are a lot of opportunities for things to go wrong in this step especially if the attendee does not follow the instructions!

* If the attendees are sharing an Azure subscription, the following items will need to be made unique in the create-cluster.sh file for each attendee:

    * resourceGroupName
    * clusterName

    The location may also potentially need to be made unique if you are getting errors related to quota.

* Azure CLI, AKS CLI and Helm will need to be installed. These are included with Azure Cloud Shell but will need to be downloaded separately if not using Cloud Shell.

* Attendees should not be using the public IP address of the PostgreSQL/MySQL containers when configuring the application.

* The attendees may make mistakes with the datasourceURL and username/password for PostgreSQL/MySQL. If the application isn't working, have the attendees check the log:

```bash
    kubectl -n {infrastructure.namespace goes here} logs deploy/contosopizza --tail=5000
    OR
    kubectl -n {infrastructure.namespace goes here} logs deploy/contosopizza
```

* [Optional] Google ReCaptcha will not work by default which means they will not be able to register as a user in the application. The attendee will need to generate their own. The instructions are here: https://github.com/pzinsta/pizzeria. The IP address for each web application will need to be registered as a domain in Google reCaptcha. 

* The approximate cost for this hack is about $15/day (using Azure Pay as You Go pricing):
    * AKS: $163/month
    * Azure DB for MySQL: $150/month
    * Azure DB for PostgreSQL: $150/month

    * Total: $464/month (plus any incidental charges for storage, private endpoints, etc.)
    
    
* This hack can be done in an Azure trial account (one attendee per Azure trial). However, Microsoft anti-fraud detection may prevent multiple Azure trial subscriptions from being created in the same network location. Also, each attendee will need a working credit card to setup an Azure trial subscription (even though the card will not be charged).

* Different database servers use different terminology. You may need to explain this to your attendees depending on their level of experience with the databases that are part of the hack. For example, in Oracle a database is a set of files while the schema is the set of objects (e.g., tables, constraints, indexes, etc.). 

* For Microsoft internal subscriptions, it appears that MS IT is applying a default NSG to the AKS subnet. If you see this, you will have to add inbound rules to the NSG in order to connect to the AKS services (e.g., port 1521 and 3000 for Oracle, port 5432 for PostgreSQL, port 3306 for MySQL and the application's ports 8081-8083)

