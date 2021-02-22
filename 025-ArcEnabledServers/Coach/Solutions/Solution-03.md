# Challenge 03: Arc Value Add: Integrate Security Center - Coach's Guide

[< Previous Challenge](./Solution-02.md) - **[Home](../readme.md)** - [Next Challenge>](./Solution-04.md)

## Notes & Guidance

1. Enable Azure Security Center on your Azure Arc connected machines.

- In the Azure portal, navigate to the Security Center blade, select **Security solutions**, and then in the **Add data sources** section select **Non-Azure servers**.
- On the **Add new non-Azure servers** blade, select the **+ Add Servers** button referencing the Log Analytics workspace you created in the previous task.
- Navigate to the **Security Center | Pricing & settings** blade and select the Log Analytics workspace.
- On the **Security Center | Getting Started** blade and enable Azure Defender on the Log Analytics workspace.
- Navigate to the **Settings | Azure Defender plans** blade and ensure that Azure Defender is enabled on 1 server.
- Switch to the **Settings | Data collection** blade and select the **Common** option for collection of **Windows security events**.
- Navigate to the **arcch-vm1** blade, select **Security**, an verify that **Azure Defender for Servers** is **On**.

### Success Criteria

1. Open Azure Security Center and view the [Secure Score](https://docs.microsoft.com/en-us/azure/security-center/secure-score-security-controls) for your Azure arc connected machine.

   >**Note**: Alternatively, review the **Security Center \| Inventory** blade and verify that it includes the **Servers - Azure Arc** entry representing the **arcch-vm1** Hyper-V VM.
