# Challenge 11: Configure Settings for User Experience

[< Previous Challenge](./10-Monitor-Manage-Performance-Health.md) - **[Home](./README.md)**

## Notes & Guidance

* Enable autoenrollment in the tenant
    - [Endpoint Manager](https://endpoint.microsoft.com) -> Devices -> Enroll devices -> Automatic enrollment -> Set MDM user scope to All or Some ensuring appropirate user targetting
    
- Enable autoenrollment via [Group Policy](https://docs.microsoft.com/en-us/windows/client-management/mdm/enroll-a-windows-10-device-automatically-using-group-policy)
    - [Troubleshooting enrollment issues](https://docs.microsoft.com/en-us/troubleshoot/mem/intune/troubleshoot-windows-auto-enrollment)
    - Device must have a user PRT before it will enroll ("dsregcmd /status" and verify that it shows AzureAdJoined, DomainJoined, and AzureAdPrt as YES)  

* Configure Universal Print
    - Ensure Universal print is enabled in your tenant. If not, you likely don't have an appropriate M365 subscription or your tenant is not in a [supported region](https://docs.microsoft.com/en-us/universal-print/fundamentals/universal-print-license#list-of-regions-where-universal-print-is-available)

* Install the Universal Print connector and register it with your tenant
    * Install has to be on a 64-bit Windows 10 1809+ or Windows Server 2016+ (preferred) system that has network visibility to both the printer and the web service endpoints
    * Pay attention to the [prerequisites](https://docs.microsoft.com/en-us/universal-print/fundamentals/universal-print-connector-installation)
   
   **NOTE:** Though some printers natively support Universal Print and don't require the connector.  At this time, most printers do not natively support Universal Print (yet), therefore they will most likely need to leverage the Universal Print connector every time.*

* [Register printers with the print connector](https://docs.microsoft.com/en-us/universal-print/fundamentals/universal-print-connector-printer-registration)
    * The printer can't be installed as a shared printer from another device.  It needs to be installed directly on the system running the connector (doesn't have to necessarily be physically connected).
    * If you unregister the printer, you will likely need to cycle the "Print Connector Service" service to get it to stop showing up as registered in the connector tool*

* In the [admin portal](https://portal.azure.com/#blade/Universal_Print/MainMenuBlade/Printers), grant user permissions for the printer and share it with either a group or everyone

* Add the printer manually on your AVD and print a test page
    * If everything looks good, but the print job just sits in a pending state try removing the printer registration from the portal and readding it on the connector system again (seems to clear up most issues), you should also verify drivers, and potentially can solve issues by enabling "Document conversion" in the admin portal

### Deploying to devices

1. Download the [Universal Print printer provisioning tool](https://www.microsoft.com/en-us/download/details.aspx?id=101453) ***and*** sample policy (have to check both boxes)
1. Deploy the included intunewin file to the systems first to prep them for provisioning
1. The ID you need for printers.csv is in the Azure portal under the printer's share blade
1. InstallPolicy.cmd and the updated printers.csv are the only files that need to be in the source folder the intunewin utility

## Learning Resources

- [Set up Azure MFA and Conditional Access](https://docs.microsoft.com/en-us/azure/virtual-desktop/set-up-mfa)
- [Device restrictions](https://docs.microsoft.com/en-us/mem/intune/configuration/device-restrictions-windows-10)
- Windows Update for Business - [Intune](https://docs.microsoft.com/en-us/windows/deployment/update/deploy-updates-intune),[Group Policy](https://docs.microsoft.com/en-us/windows/deployment/update/waas-wufb-group-policy)
- [Universal Print Intune Tool](https://docs.microsoft.com/en-us/universal-print/fundamentals/universal-print-intune-tool)
- [Remove Universal Print Connector (If needed)](https://docs.microsoft.com/en-us/universal-print/fundamentals/universal-print-remove-connector-howto)
- [Microsoft Defender for Endpoint](https://docs.microsoft.com/en-us/mem/configmgr/protect/deploy-use/defender-advanced-threat-protection#bkmk_any_os)
