# Challenge 1: Coach's Guide

[< Previous Challenge](./00-prereqs.md) - **[Home](README.md)** - [Next Challenge >](./02-acr.md)

## Notes & Guidance
package link	https://csasapdemo.blob.core.windows.net/saptools/OPHK-2021-0415.tar.gz?sp=r&st=2021-04-16T15:23:09Z&se=2022-04-16T23:23:09Z&spr=https&sv=2020-02-10&sr=b&sig=17oTU7%2F2tyGUqEdD7CFLWpUi7N0rOi4I1aZMva8ICWs%3D
	
putty link	https://csasapdemo.blob.core.windows.net/saptools/putty.exe?sp=r&st=2021-03-05T18:25:36Z&se=2022-03-06T02:25:36Z&spr=https&sv=2020-02-10&sr=b&sig=TBEcQMZgVKmD7a%2FCgEJTRdotZcltmXX%2FUtZRDBwIJyc%3D

SAP GUI link	https://csasapdemo.blob.core.windows.net/saptools/SAPGUI.ZIP?sp=r&st=2021-03-02T22:27:06Z&se=2022-03-03T06:27:06Z&spr=https&sv=2020-02-10&sr=b&sig=gX3hoi5oNQKwZ3mtRg%2B%2BL01X9Jf%2BYWw7qIU3VjZn6eM%3D

HANA studio link	https://csasapdemo.blob.core.windows.net/saptools/SAP_HANA_STUDIO.zip?sp=r&st=2021-03-02T22:26:19Z&se=2022-03-03T06:26:19Z&spr=https&sv=2020-02-10&sr=b&sig=434PUw8cckZyKijmjtjhWzfJ8%2B4H601o2cyU2fPGq6Y%3D
	
	
jumpbox login:

azureuser/Welcome!2345
	
OS:	

sidadm	Welcome12345
	
SAP app:	

client 000	DDIC/Basis123

client 100	BPINST/Welcome1
	
HANA DB:	

SYSTEMDB	Welcome12345

tenantDB (S4P)	Basis123

![image](https://user-images.githubusercontent.com/81709232/115639236-f1463080-a2c8-11eb-813e-9f5f3a23cc82.png)

## important notes

step 5	Make sure that it is ubuntu server, account 'azureuser'

step 6	Make sure that the participants run 'local_Setup.sh'

step 9	E32 server provision could take long. If Azure failed to provision it, participant needs to delete all resources within the resource group and the resource group itself.

step 10	 Make sure that ANF root access flag set to "on" for all ANF vols.

