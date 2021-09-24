# Challenge 0: Environment Setup - Coach's Guide

**[Home](./README.md)** - [Next Challenge >](./01-design.md)

## Before you start

- Introduce housekeeping: breaks, lunch, cameras on ideally, etc

## Solution Guide

- Provision the onprem environment before the lab:

```bash
# Onprem
rg_onprem=migratefasthack-onprem
location=westeurope
template_uri="https://cloudworkshop.blob.core.windows.net/line-of-business-application-migration/sept-2020/SmartHotelHost.json"
az group create -n "$rg_onprem" -l "$location"
az deployment group create -n "${rg_onprem}-${RANDOM}" -g $rg --template-uri $template_uri # The default credentials are demouser/demo!pass123
# Azure Prod
rg_azure_prod=migratefasthack-azure-prod
az group create -n "$rg_azure_prod" -l "$location"
# Azure Test
rg_azure_test=migratefasthack-azure-test
az group create -n "$rg_azure_test" -l "$location"
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
    rg_array=( "$rg_onprem" "$rg_azure_prod" "$rg_azure_test" )
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
    cat <<EOF > $custom_role_file
{
  "Name": "Migration Admin",
  "IsCustom": true,
  "Description": "Migration Administrator",
  "Actions": [
    "Microsoft.KeyVault/register/action",
    "Microsoft.Migrate/register/action",
    "Microsoft.OffAzure/register/action"
   ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/$subscription_id"
  ]
}
EOF
    az role definition create --role-definition "$custom_role_file"
    # Assign role to user
    az role assignment create --scope $subscription_scope --role "Migration Administrator" --assignee $user_object_id -o none
done
```

**Note**: you need to grant some permission in the subscription level, otherwise you would get the error `{"error":{"code":"AuthorizationFailed","message":"The client 'hacker01@cloudtrooper.net' with object id '907c07ad-4bb3-4c91-b360-10bae02de678' does not have authorization to perform action 'Microsoft.KeyVault/register/action' over scope '/subscriptions/e7da9914-9b05-4891-893c-546cb7b0422e' or the scope is invalid. If access was recently granted, please refresh your credentials."}} {"error":{"code":"AuthorizationFailed","message":"The client 'hacker01@cloudtrooper.net' with object id '907c07ad-4bb3-4c91-b360-10bae02de678' does not have authorization to perform action 'Microsoft.Migrate/register/action' over scope '/subscriptions/e7da9914-9b05-4891-893c-546cb7b0422e' or the scope is invalid. If access was recently granted, please refresh your credentials."}} {"error":{"code":"AuthorizationFailed","message":"The client 'hacker01@cloudtrooper.net' with object id '907c07ad-4bb3-4c91-b360-10bae02de678' does not have authorization to perform action 'Microsoft.OffAzure/register/action' over scope '/subscriptions/e7da9914-9b05-4891-893c-546cb7b0422e' or the scope is invalid. If access was recently granted, please refresh your credentials."}}`

If you need to delete the users, you can use this script:

```bash
# Delete created users
user_no=2
for ((i=1;i<=user_no;i++)); do
    user_id=hacker$(printf "%02d" $i)
    user_principal="${user_id}@${domain}"
    user_object_id=$(az ad user show --id "$user_principal" --query objectId -o tsv)
    rg_array=( "$rg_onprem" "$rg_azure_prod" "$rg_azure_test" )
    for rg in "${rg_array[@]}"
    do
        echo "Deleting contributor role for $user_principal (object ID $user_object_id) on RG $rg..."
        rg_id=$(az group show -n $rg --query id -o tsv)
        az role assignment delete --scope $rg_id --role Contributor --assignee $user_object_id -o none
    done
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
