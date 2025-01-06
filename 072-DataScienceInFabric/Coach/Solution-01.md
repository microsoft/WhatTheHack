# Challenge 01 - Bring your data to the OneLake - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

In this challenge, hack participants must create a shortcut to the folder deployed in their Azure subscription on Challenge 0. This will allow them to use the data in Fabric without the need for replication. Once the shortcut is completed, participants will open Notebook 1 to load the csv file into a delta table for further modification on Notebook 2.

### Sections

1. Create a Lakehouse (non-notebook)
2. Create a Shortcut (non-notebook)
3. Read the .csv file into a dataframe in the notebook (Notebook 1)
4. Write the dataframe to the lakehouse as a delta table (Notebook 1)
   
### Student step-by-step instructions (creating a shortcut)
- Creating a Lakehouse:
  -  Participants must create a lakehouse on the Fabric workspace they previously set up. In Fabric, navigate to the workspace.
  -  On the top left of the screen, select new and more options.
  -  On the data engineering section, select Lakehouse. Give the lakehouse a unique name and click on create.
    
- Creating a Shortcut:
  - On the Lakehouse navigator, use the left hand-side menu and click on the 3 dots (...) next to files. Click on "New shortcut"
  - On the shortcut wizard, click on "Azure Data Lake Storage Gen2"
  - Go to your Azure portal. The URL can be found on the **Settings>Endpoint** side menu of the Storage Account. In this menu, you will see a variety of endpoint Resource IDs and URLs. Find and copy the **data lake storage URL** from the list. Enter it into the wizard in Fabric.
  - Create a new connection, give it a name and select "Account Key" as the authentication kind.
  - Go back to your Azure portal. The Account Key can be found on in the **Security + Networking>Access keys** side menu of the Storage Account. Show and copy one of the keys. Enter it into the wizard in Fabric.
  - Click on next to access the file explorer. Wait for the screen to load.
  - On the side menu, expand the file-system folder. Select the check mark next to the "files" folder.
  - Click next to move to the next screen, then click on create to create the shortcut.
  - Verify that your shortcut is showing under the **Files** folder of the lakehouse navigator. You might need to click on the 3 dots and on refresh if your shortcut is not present initially.

### Overview of student directions (running Notebook 1)
- This section of the challenge is notebook based. All the instructions and links required for participants to successfully complete this section can be found on Notebook 1 in the `student/resources.zip/notebooks` folder.
- To run the notebook, go to your Fabric workspace and select Notebook 1. Ensure that it is correctly attached to the lakehouse. You might need to connect to the lakehouse you previously created on the left-hand side file explorer menu.
- The students must follow the instructions, leverage the documentation and complete the code cells sequentially.

### Coaches' guidance
- This challenge has 2 main sections, creating a shortcut and loading the files into delta tables. The first section must be completed before working on Notebook 1.
- The full version of Notebook 1, with all code cells filled in, can be found for reference in the `coach/solutions` folder.
- The aim of this challenge, as noted in the student guide, is to understand lakehouses, shortcuts and the delta format.
- To assist students, coaches can clear up doubts regarding the Python syntax or how to get started with notebooks, but students should focus on learning how to set up shortcuts, navigate the Fabric UI and read/write to the delta lake.
  
## Success criteria
  - The heart.csv data is now saved as a delta table on the lakehouse
