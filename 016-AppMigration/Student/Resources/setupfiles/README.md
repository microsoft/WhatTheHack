This folder contains files needed to setup the labs.

- **TailwindInventory.bacpac** - The backup of the inventory database on the SQL server.

- **inventory.bson** - The backup file for the product MongoDB database

- **inventory.metadata.json** - Metadata file for the product MongoDB backup

This material was original created for a set of events running at the Microsoft Technology Centers Sept - Dec 2019.  During this time a shared Mongo DB machine was running for Lab 1.  Students used this as a shared resource to connect to and practice migrating data from an on premise MongoDB to Cosmos DB.

If that VM is no longer accessible you can create one yourself by the following steps:

1. Create an Azure VM based on a MongoDB instance.  The one we used originally was the Jetware Image.

1. Make sure the DB service is running.

1. Install the MongoDB tools if needed

   1. sudo apt install mongo-clients

1. clone this repo that has the inventory.bson files in the setupfiles directory

1. cd to the setupfiles directory

1. Restore the inventory database

   1. ```bash
      mongorestore inventory.bson --db=tailwind
      ```

1. Create the user the lab has the students connect to

   1. ```bash
      db.createUser({user: "labuser", pwd:"AzureMigrateTraining2019#", roles:[{role: "read", db:"tailwind"}]})
      ```

1. Open the firewall ports on the VM for:

   1. SSH: **22**
   2. MongoDB:  **27017**

1. Make sure you update your students to use the IP of your new machine.  You may also want to make that a static IP address.

