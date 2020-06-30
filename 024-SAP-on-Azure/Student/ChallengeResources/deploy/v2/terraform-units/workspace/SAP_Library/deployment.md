### <img src="../../../../../documentation/assets/UnicornSAPBlack256x256.png" width="64px"> SAP Automation > Terraform > Units > SAP Library
# Deployment

## Common Setup
*This step may have been previously completed*
1. Create an SAP Automation root directory and descend into the newly created <automation_root>

   > `mkdir <automation_root> && cd $_`

2. Clone the Repository.

   - HTTPS

     > `git clone https://github.com/Azure/sap-hana.git`

   - SSH

     > `git clone git@github.com:Azure/sap-hana.git`

<br>

## Setup Workspace

1. Create a *Workspace Container* under the <automation_root> and descend into the newly created *Workspace Container*.

   > `mkdir -p <automation_root>/Terraform/workspace/SAP_Library && cd $_`

2. Create a *Workspace* within the newly created *Workspace Container* and descend into the newly created *Workspace*.
   - We recommend an easily identifiable naming convention that uniquely and globally identify the deployment.
   <br>For example: `PROTO-SCUS-SAP_Library`
     - The first  field represents the subscription.
     - The second field represents the region.
     - The third  field represents the deployment unit.

   > `mkdir PROTO-SCUS-SAP_LIBRARY && cd $_`

<br>

## Setup and configure for the Run

1. Copy the parameter template

    > `cp <automation_root>/sap-hana/deploy/v2/terraform-units/workspace/SAP_Library/TFE/variables.auto.tfvars .`

2. Edit the parameter file

| Parameter  | Description                                                    |
| :---       | :---                                                           |
| deployZone | Subscription identifyer for environment partitioning           |
| region     | Azure Region in which to deploy resources                      |
| tags       | A map of keys and values with which resources are to be tagged |

3. [Initialize](#initialize) - Initialize the Terraform Workspace

4. [Plan](#plan) - Plan it. Terraform performs a deployment check.

5. [Apply](#apply) - Execute deployment.

<br><br><br>

## Terraform Operations

- From the Workspace directory that you created.

<br>

### Initialize

- Initializes the Workspace by linking in the path to the runtime code and downloading execution Providers.

  ```bash
  terraform init <automation_root>/sap-hana/deploy/v2/terraform-units/workspace/SAP_Library/TFE
  ```

- To re-initialize, add the `--upgrade=true` switch.

  ```bash
  terraform init --upgrade=true <automation_root>/sap-hana/deploy/v2/terraform-units/workspace/SAP_Library/TFE
  ```

<br>

### Plan

- A plan tests the *code* to see what changes will be made.
- If a Statefile exists, it will compare the *code*, the *statefile*, and the *resources* in Azure in order to detect drift and will display any changes or corrections that will result, and the actions that will be performed.

```
terraform plan  <automation_root>/sap-hana/deploy/v2/terraform-units/workspace/SAP_Library/TFE
```

<br>

### Apply

- Apply executes the work identified by the Plan.
- A Plan is also an implicit step in the Apply that will ask for confirmation.

  ```bash
  terraform apply <automation_root>/sap-hana/deploy/v2/terraform-units/workspace/SAP_Library/TFE
  ```

- To automatically confirm, add the `--auto-approve` switch.

  ```bash
  terraform apply --auto-approve <automation_root>/sap-hana/deploy/v2/terraform-units/workspace/SAP_Library/TFE
  ```

<br>

### Destroy

- If you don't need the deployment anymore, you can remove it just as easily.
  <br>From the Workspace directory, run the following command to remove all deployed resources:

  ```bash
  terraform destroy <automation_root>/sap-hana/deploy/v2/terraform-units/workspace/SAP_Library/TFE
  ```

- To automatically confirm, add the `--auto-approve` switch.xs


  ```bash
  terraform destroy --auto-approve <automation_root>/sap-hana/deploy/v2/terraform-units/workspace/SAP_Library/TFE
  ```
