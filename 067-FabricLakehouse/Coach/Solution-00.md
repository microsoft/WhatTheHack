# Challenge 00 - Prerequisites - Grab your fins and a full tank! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Please make sure that the students review the [introduction](../README.md) and [Challenge 0 - Prerequisites - Ready, Set, GO! - Student's Guide](../Student/Challenge-00.md) ahead of time. Also ensure you have read the prerequisites section of the [Coach's Guide](./README.md).

Students will need access to a Fabric enabled workspace and Power BI desktop. Again, see the pre-reqs in the [Coach's Guide](./README.md) for more details. 

Students will need to have created a Lakehouse in their workspace either ahead of time, or on the day. This is covered in the [Create a Lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/create-lakehouse) tutorial on Learn for those not familiar.

You should provide the students with the ``resources.zip`` file and ensure they have uploaded each of the contained folders to their Lakehouse. Unfortunately, this has to be done one folder at a time so allow a small amount of time to complete. See the student resources section of the [Coach's Guide](./README.md) for details on creating the  ``resources.zip`` file.

## Gotchas

Overall, this challenge is designed to level set student environments and ensure they are ready to undertake the rest of the hack. Some things to watch out for:

1. **Fabric not enabled in the tenant.** This is a common issue and needs validating/resolving when planning the hack. During the organisation stage, ensure that tenant(s) to be used by students have been enabled for Fabric, either globally or to a specific group of users (that the student is a member of). See Enabling Microsoft Fabric in the [README](./README.md)
2. **No Fabric capacity.** A Fabric capacity is required. A small SKU is acceptable (F2-F4). A trial developer subscription may be of use as well. See [README](./README.md)
3. **Workspace not Fabric enabled, or no permissions to create new workspace.** Ideally, a new workspace should be created for each student ahead of time either by their tenant admin or, if they have permissions, themselves.  Students require at least Contributor role, although workspace Admin is suggested. See [learn.microsoft.com/en-us/fabric/get-started/workspaces](https://learn.microsoft.com/en-us/fabric/get-started/workspaces)
4. **Uploading Data to Wrong Location** You should ensure the students upload the data to the correct location (i.e., Files/Raw, Files/Bronze etc) not Files/data/Raw etc. This is a common mistake and can be confusing for students especially if you later provide them with the included code hints/solutions.


