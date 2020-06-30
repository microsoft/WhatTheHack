# HANA high-availability pair

This scenario deploys a single-node HANA instance in two sites (primary and secondary), replicated on database level via HANA System Replication (HSR). This scenario is known as "high-availability pair" or "HA pair."

<img src="https://raw.githubusercontent.com/Azure/sap-hana/1790182ba0e00a0731d48560573c00fba79b553b/deploy/vm/modules/ha_pair/sld-hapair.png" alt="Landscape Diagram" width="800"/>

## Table of contents

- [Considerations](#considerations)
- [Features](#features)
- [Usage](#usage)

## Considerations
- This scenario already configures all resources required for the Pacemaker HA cluster, including:
  - STONITH by device (SBD), via iSCSI target server
  - SAPHanaSR and SAPHanaTopology Pacemaker resource agents (to facilitate HSR failover)
  - azure-events Pacemaker resource agent (to anticipate scheduled maintenance events and trigger graceful failover)
- In this design, the SBD device uses a iSCSI target server on an additional VM; while this is optional, it allows for faster failover. For more details, please refer to the [reference architecture of high-availability VM landscapes using Pacemaker on SuSE Linux Enterprise Server (SLES)](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/high-availability-guide-suse-pacemaker).
- At present, this HANA high-availability scenario is only supported for Azure VM deployments using SuSE Linux Enterprise Server (SLES) 12.3 or higher.
- For additional details on the underlying implementation, please see the [documentation of the reference architecture](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/sap-hana-high-availability).
- If you don't have a high-availability requirement, you can just deploy the [HANA single-node scenario](../single_node_hana).

## Features

The following options can be customized in the single-node scenario:

| Option  | Description | Template parameter  |
| ------------ | ------------------------ | ------------ |
| **HANA version**  <td colspan=3> *Which version of HDB Server to install*
|   | HANA 1.0 SPS12 (PL13 or higher)  | `useHana2 = false`  |
|   | HANA 2.0 SPS2 or higher  | `useHana2 = true`  |
| **Database containers** * <td colspan=3> *Whether to install HDB with single or multiple database containers (tenants)*
|   | Single container (HANA 1.0 only)  | `hdb_mdc = false`  |
|   | Multi-database containers (MDC)  | `hdb_mdc = true`   |
| **Bastion host** * <td colspan=3> *Whether to deploy a bastion host ("jump box") through which the HANA VM can be accessed*
|   | No bastion host  | `windows_bastion = false`<br>`linux_bastion = false`  |
|   | Windows bastion host (incl. HANA Studio)  | `windows_bastion = true`  |
|   | Linux bastion host (incl. HANA Studio)  | `linux_bastion = true`  |
| **SAP Applications**  <td colspan=3> *Which SAP applications to install on top of HANA (if any)*
|   | XSA  | `install_xsa = true`  |
|   | [SAP HANA Cockpit](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.03/en-US/da25cad976064dc0a24a1b0ee9b62525.html) (requires XSA) | `install_cockpit = true`  |
|   | [SHINE Demo Content](https://blogs.saphana.com/2014/03/10/shine-sap-hana-interactive-education/) (requires XSA)  | `install_shine = true`  |
|   | [WebIDE](https://developers.sap.com/topics/sap-webide.html) (requires XSA)  | `install_webide = true`  |

 *(**Note**: Features marked with an * are work in progress and not fully available yet.)*

## Usage

1. If you haven't already done so, please make sure you [prepare your Azure Cloud Shell](https://github.com/Azure/sap-hana#preparing-your-azure-cloud-shell).

2. Next, [download the required SAP packages and make them accessible](https://github.com/Azure/sap-hana#getting-the-sap-packages).

 *(**Note**: Please review the [list of SAP downloads](https://github.com/Azure/sap-hana#required-sap-downloads); depending on which features and applications you would like to include in your HANA installation, you may need additional packages.)*

3. In your Azure Cloud Shell, change into the directory for the HANA high-availability pair:

    ```sh
    cd sap-hana/deploy/vm/modules/ha_pair/

4. Create a `terraform.tfvars` file for your deployment. You can use the provided [Boilerplate template ](terraform.tfvars.template) for high-availability pair scenarios as a starting point and adjust the variables according to your requirements.

 *(**Note**: You need to rename the boilerplate template from `terraform.tfvars.template` to `terraform.tfvars` before you can use it.)*

5. Now, [run the deployment](https://github.com/Azure/sap-hana#running-the-deployment) of your HANA high-availability pair instance. You can [verify the installation](https://github.com/Azure/sap-hana#verifying-the-deployment) afterwards.

6. Should you wish to delete your HANA high-availability pair at a later point, you can simply [follow the general instructions on the overview page](https://github.com/Azure/sap-hana#deleting-the-deployment).
