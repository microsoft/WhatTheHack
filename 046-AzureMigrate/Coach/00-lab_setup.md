# Challenge 0: Environment Setup - Coach's Guide

**[Home](./README.md)** - [Next Challenge >](./01-design.md)

## Before you start

- Introduce housekeeping: breaks, lunch, cameras on ideally, etc

## Solution Guide

- Provision the onprem environment before the lab:

```bash
# Variables
location=westeurope
# Deploy template  (the default credentials are demouser/demo!pass123)
# Parameters: resourceGroupBaseName, includeLandingZone
template_uri="https://openhackpublic.blob.core.windows.net/lob-migration/sept-2021/SmartHotelFull.json"
base_name=FastHack
az deployment sub create -n "${rg_onprem}-${RANDOM}" --template-uri $template_uri -l $location --parameters resourceGroupBaseName=$base_name includeLandingZone=true
# The template will create two resource groups
rg_onprem="${base_name}HostRG"
rg_azure_prod="${base_name}RG"
```

- Create users with permissions to the lab:

```bash
# Create users and grant Contributor access to the previously created RGs
domain=$(az account show -o tsv --query user.name | cut -d@ -f 2)
user_no=2
for ((i=1;i<=user_no;i++)); do
    user_id=hacker$(printf "%02d" $i)
    user_principal="${user_id}@${domain}"
    user_password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-12};echo;)
    user_object_id=$(az ad user show --id "$user_principal" --query objectId -o tsv)
    if [[ -z "$user_object_id" ]]
    then
        echo "Creating user ${user_principal}, password ${user_password}..."
        az ad user create --display-name "$user_id" --user-principal-name "$user_principal" --password "$user_password" -o none
        user_object_id=$(az ad user show --id "$user_principal" --query objectId -o tsv)
    else
        echo "User ${user_principal} already exists"
    fi
    echo "Creating role assignments for user $user_principal..."
    rg_array=( "$rg_onprem" "$rg_azure_prod" )
    for rg in "${rg_array[@]}"
    do
        echo "Adding contributor role for $user_principal on RG $rg..."
        rg_id=$(az group show -n $rg --query id -o tsv)
        az role assignment create --scope $rg_id --role Contributor --assignee $user_object_id -o none
    done
    echo "Adding role assignments at the subscription level..."
    # Create custom role
    subscription_id=$(az account show --query id -o tsv)
    subscription_scope="/subscriptions/${subscription_id}"
    custom_role_file=/tmp/customrole.json
    # Note: the action on "services" is not available in the API, only "sqlMigrationServices", however it is required by the portal, hence using star wildcard
    cat <<EOF > $custom_role_file
{
  "Name": "Migration Admin",
  "IsCustom": true,
  "Description": "Migration Administrator",
  "Actions": [
    "Microsoft.KeyVault/register/action",
    "Microsoft.Migrate/register/action",
    "Microsoft.OffAzure/register/action",
    "Microsoft.Resources/deployments/*/read",
    "Microsoft.Resources/deployments/*/write",
    "Microsoft.Network/networkInterfaces/ipConfigurations/read",
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.DataMigration/sqlMigrationServices/*/action",
    "Microsoft.DataMigration/sqlMigrationServices/*/delete",
    "Microsoft.DataMigration/sqlMigrationServices/*/read",
    "Microsoft.DataMigration/sqlMigrationServices/*/write",
    "Microsoft.DataMigration/locations/*/read",
    "Microsoft.DataMigration/*/action",
    "Microsoft.DataMigration/*/delete",
    "Microsoft.DataMigration/*/read",
    "Microsoft.DataMigration/*/write"
   ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/$subscription_id"
  ]
}
EOF
    role_id=$(az role definition list -n "Migration Admin" --query '[].id' -o tsv)
    if [[ -z "$role_id" ]]
    then
        echo "Role Migration Admin could not be found, creating new..."
        az role definition create --role-definition "$custom_role_file"
        role_id=$(az role definition list -n "Migration Admin" --query '[].id' -o tsv)
    else
        echo "Role Migration Admin already exists, updating..."
        az role definition update --role-definition "$custom_role_file"
    fi
    # Assign role to user
    az role assignment create --scope $subscription_scope --role $role_id --assignee $user_object_id -o none
done
```

If you need to delete the users, you can use this script:

```bash
# Delete created users
user_no=2
for ((i=1;i<=user_no;i++)); do
    user_id=hacker$(printf "%02d" $i)
    user_principal="${user_id}@${domain}"
    user_object_id=$(az ad user show --id "$user_principal" --query objectId -o tsv)
    rg_array=( "$rg_onprem" "$rg_azure_prod" )
    for rg in "${rg_array[@]}"
    do
        echo "Deleting contributor role for $user_principal (object ID $user_object_id) on RG $rg..."
        rg_id=$(az group show -n $rg --query id -o tsv)
        az role assignment delete --scope $rg_id --role Contributor --assignee $user_object_id -o none
    done
    role_id=$(az role definition list -n "Migration Admin" --query '[].id' -o tsv)
    if [[ -n "$role_id" ]]
    then
        echo "Deleting assignment to role ID $role_id for $user_principal at the subscription level..."
        subscription_id=$(az account show --query id -o tsv)
        subscription_scope="/subscriptions/${subscription_id}"
        az role assignment delete --scope $subscription_scope --role $role_id --assignee $user_object_id -o none
    fi
    echo "Deleting user ${user_principal}..."
    az ad user delete --id $user_principal -o none
done
```

- As a coach you would have created 3 (?) RGs in our sub as well as a couple of accounts which have contributor access to each (easier than giving cx accounts access?):
    - OnPrem <- has the Hyper-V / on-prem environment
    - Target <- potentially has the target vnet
    - Test <- potentially another vnet to do test failovers to
- Make sure participants test connectivity to Azure
- Connectivity to Azure host VM:
    - RDP vs Bastion? <- start with RDP, only if necessary consider Bastion (i.e. if outbound RDP blocked)
    - Accept RDP open to internet is a security risk

- The SmartHotel application should look something like this:

![smarthotel app](./Images/smarthotel_app_portal.png)

- If there are no records shown in the UI, it could be because the database was deployed too long ago (a couple of days would be enough to make no records appear). To fix this, you can change the underlying database, so that records are shown:
    1. RDP into the SQL VM
    1. Open SQL Server Management Studio
    1. Locate the database `SmartHotel.Registration`
    1. In that database, locate the table `dbo.Bookings`
    1. Right click, and select the command `Edit Top 200 Rows`
    1. Change some checkin or checkout dates to today's date

![smss](./Images/ssms.png)

- You might want to take checkpoints of the nested VMs with Hyper-V manager, just in case (especially for the SQL1 one)
- Note that the SQL1 nested VM seems to reboot every hour due to an expired evaluation license. You can re-arm the evaluation with the command `Slmgr.vbs -rearm`. This should prevent reboots for some days.
