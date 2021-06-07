# Challenge 11: Configure Settings for User Experience

[< Previous Challenge](./10-Monitor-Manage-Performance-Health.md) - **[Home](../README.md)**

## Introduction

In this challenge you will be setting up autoenrollment into MDM for your AVD devices. You will then enhance the security of the devices by enabling MFA via conditional access policy and setting up automatic updates via Windows Update for Business. Finally, you will enable Universal Print and deliver printer config to your AVD(s) via Intune.

**NOTE:** Intune doesn't currently support management of Windows 10 Enterprise multi-session.  The following should be performed on single session hosts only.

## Description

- Intune Autoenrollment
    - Enable MDM autoenrollment in your Azure AD Tenant and through Group Policy
        * **HINT:** Both AAD and Group Policy changes are required here
    - Setup hybrid AAD devices using Azure AD Connect

- Secure the endpoint
    - Create a group in Azure AD and add your devices as members
    * Enable Azure multifactor authentication in your tenant
        - **TIP:** Enable Microsoft Authenticator passwordless sign-in as a method in AAD
    * Create and assign a Conditional Access policy to your users
        - Require MFA
        - Target the appropriate AVD app for your scenario
        - Target both Browsers and "Mobile apps and desktop clients"

    - Create a Windows Update for Business policy in either [Intune](https://docs.microsoft.com/en-us/windows/deployment/update/deploy-updates-intune) or [Group Policy](https://docs.microsoft.com/en-us/windows/deployment/update/waas-wufb-group-policy)
        - **TIP:** Consider the end user experience when developing your policy

    - Create a device restriction configuration profile and apply it to your device group

- Universal Print
    - Install the universal print connector on a member server or client
    - Register at least one printer with the print connector
    - Share the printer from Universal Print
    - Grant users in your tenant permissions for the printer
    - *Optional:* Manually add the printer on a AVD to ensure everything is working
    - Deploy your printer to a group of devices in the MEM portal
        - **HINT:** Use the Universal Print printer provisioning tool and the included sample policy to get you started
        - **TIPS:** 
            - When you go to assign the custom win32 app to the group, change end user notficiations to "Hide all toast notifications" so that the install is transparent to the user
            - Once both your provisioning and policy applications have installed, you will need to log off and back on before the printer will become available

## Success Criteria

1. AVD devices automatically enroll into Intune
1. MFA is required for access
1. Windows updates are automatically installed
1. Security requirements are enforced by device restrictions
1. Universal Print printers are available to your users and automatically installed on devices via AAD group membership

## Advanced Challenges (Optional)

1. Sign up for a free [Microsoft Defender for Endpoint](https://www.microsoft.com/en-us/microsoft-365/security/endpoint-defender) trial (can take serveral days for approval) and onboard your devices to it
1. Create additional configuration profiles within MEM to further customize the user experience
    * **HINT:** Think of device configurations you've regularly deployed through Group Policy
