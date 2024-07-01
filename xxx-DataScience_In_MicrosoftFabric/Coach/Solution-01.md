# Challenge 01 - Bring your data to the OneLake - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

In this section, hack participants must create a shortcut to the folder deployed in their Azure subscription on Challenge 0. This will alow them to use the data in Fabric without the need for replication. Once the shortcut is completed, participants will open Notebook 1 to load the csv file into a delta table for further modification on notebook 2.

- Creating a Lakehouse:
  -  Participants must create a lakehouse on the Fabric workspace they previously set up. In Fabric, navigate to the workspace.
  -  On the top left of the screen, select new and more options.
  -  On the data engineering section, select Lakehouse. Give the lakehouse a name and click on create.
    
- Creating a Shortcut:
  - On the Lakehouse navigator, use the left hand-side menu and click on the 3 dots (...) next to files. Click on "New shortcut"
  - On the shortcut wizard, click on "Azure Data Lake Storage Gen2"
  - The URL can be found on the Settings>Endpoint side menu of the Storage Account. Find and copy the data lake storage URL from the list. Enter it into the wizard in Fabric.
  - Create a new connection, give it a name and select "Account Key" as the authentication kind.
  - The Account Key can be found on in the Security + Networking>Access keys side menu of the Storage Account. Copy one of the keys. Enter it into the wizard in Fabric.
  - Click on next to access the file explorer.
  - On the side menu, expand the file-system folder. Select the checkmark next to the "files" folder.
  - Click next to move to the next screen, then click on create to create the shortcut.
  - Verify that your shortcut is showing under the Files folder of the lakehouse navigator. You might need to click on the 3 dots and on refresh if your shortcut is not present initially.

- Running notebook 1:
  - Go back to your workspace and select Notebook 01-Ingest-Heart-Failure...
  - Complete and run each cell sequentially in the notebook, using the instructions and documentation links.
  - Note: the full completed notebook is available in the coach resources folder in GitHub for reference.

- Exit criteria:
  - The heart.csv data is now saved as a delta table on the lakehouse
