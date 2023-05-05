# bin/bash
###################################################################################################################################
#
# wth-teardown.sh - Helper script to remove the Hackathon resources post event when working in shared Azure Subscription 
# and GitHub Organisation.
#
###################################################################################################################################
#
# Description:
# This script is designed to help you remove the previously create Hackathon resources when working in a shared Azure Subscription 
# and GitHub Org. It essentially reverses the wth-setup.sh script.
# 
# The script will remove the resource groups, users, service principals and GitHub repos for each team. It will also remove the 
# repos for all the teams and the shared internal repo.
#
# Assumptions:
#   - You have the Azure CLI installed and logged in before running
#   - You have the GitHub CLI installed and logged in before running
#   - You have jq installed
#   - You have a GitHub Organisation created and you are an owner/admin (set the name as a environment variable below before running)
#   - You have a Azure Subscription created and you are an owner (set the name as a environment variable below before running)
#   - You know the group count for the hackathon (set the name as a environment variable below before running)
#
###################################################################################################################################

# The number of groups in the hackathon
GROUP_COUNT=25

# The Azure subscription ID
SUBSCRIPTION_ID=<AZURE-SUBSCRIPTION-ID>

# The organisation in GitHub
ORGANISATION=<GITHUB-ORGANISATION-NAME e.g. wth-devops-london>

# Set the subscription
az account set --subscription $SUBSCRIPTION_ID
DOMAIN=$(az rest --method get --url 'https://graph.microsoft.com/v1.0/domains?$select=id' --query '"value"' | jq '.[0].id' --raw-output) 

# Create all the Azure resource groups and user/service principals
for i in $(seq $GROUP_COUNT); do
    # Remove service principal
    echo "Removing service principal wth-team$i"
    APPID_TO_DELETE=$(az ad sp list --display-name wth-team$i | jq '.[0].appId' --raw-output)
    echo "Removing service principal $APPID_TO_DELETE"
    az ad sp delete --id $APPID_TO_DELETE

    APPID_TO_DELETE=$(az ad app list --display-name wth-team$i | jq '.[0].appId' --raw-output)
    echo "Removing AppID $APPID_TO_DELETE"
    az ad app delete --id $APPID_TO_DELETE

    # Remove team upn
    echo "Removing team user $TEAM_UPN"
    TEAM_UPN=wth-team$i@$DOMAIN
    az ad user delete --id $TEAM_UPN

    echo "Removing resource group wth-team$i-rg"
    az group delete --name wth-team$i-rg --no-wait --yes
done

# Delete the teams from GitHub
for i in $(seq $GROUP_COUNT); do
    TEAMNAME=wth-team$i
    gh api --method DELETE -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28"  /orgs/$ORGANISATION/teams/$TEAMNAME --silent
done

# Delete the team repos
for i in $(seq $GROUP_COUNT); do
    # delete a team repo
    echo "Deleting team repo $ORGANISATION/wth-team$i"
    gh repo delete $ORGANISATION/wth-team$i --yes
done

# create the shared teams repo (for credential distribution in issues)
echo "Deleting team repo $ORGANISATION/wth-teams"
gh repo delete $ORGANISATION/wth-teams --yes

echo "Done!"
