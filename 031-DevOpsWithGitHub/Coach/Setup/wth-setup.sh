# bin/bash
###################################################################################################################################
#
# wth-setup.sh - Helper script to create the Hackathon resources when working in shared Azure Subscription and GitHub Organisation
#
###################################################################################################################################
#
# Description:
# This script is designed to help you create the Hackathon resources when working in a shared Azure Subscription and GitHub Org.
# For face-to-face events you may want to provide the attendees with a repo with the files they need to complete the hack and
# a route for them to deploy resources into Azure. In this instance this script assumes you have a shared Azure Subscription and
# each team will deploy resources into their own resource group.
#
# The script will create the resource groups, users, service principals and GitHub repos for each team. It will also create a 
# internal repo on the org that the attended will be able to view and coaches can use to share the credentials for the
# service/user principals. The service principal can be used in the workflows to deploy resources into Azure by copying and 
# pasting the JSON into repo secrets. Teams can access the portal via a user credential. Coaches have credentials too under
# the wth-coach-teamX@<domain> user.
#
# Assumptions:
#   - You have the Azure CLI installed and logged in before running
#   - You have the GitHub CLI installed and logged in before running
#   - You have jq installed
#   - You have a GitHub Organisation created and you are an owner/admin (set the name as a environment variable below before running)
#   - You have a Azure Subscription created and you are an owner (set the name as a environment variable below before running)
#   - You know the group count for the hackathon (set the name as a environment variable below before running)
#   - You have a directory containing the Hackathon resource files (set the name as a environment variable below before running)
#   - You have a password for the users and coaches (set the name as a environment variable below before running)
#
# Interesting Fact: Copilot wrote a massive percentage of this script and this desciption :-)
#
###################################################################################################################################

# The number of groups in the hackathon
GROUP_COUNT=25

# The Azure subscription ID
SUBSCRIPTION_ID=<AZURE-SUBSCRIPTION-ID>

# The organisation in GitHub
ORGANISATION=<GITHUB-ORGANISATION-NAME e.g. wth-devops-london>

# The directory containing the Hackathon resource filed
RESOURCE_DIR=../../Student/Resources

# The password for the users
PASSWORD=


# Set the subscription
az account set --subscription $SUBSCRIPTION_ID
DOMAIN=$(az rest --method get --url 'https://graph.microsoft.com/v1.0/domains?$select=id' --query '"value"' | jq '.[0].id' --raw-output) 

mkdir -p AzureCredentials
# Create all the Azure resource groups and user/service principals
for i in $(seq $GROUP_COUNT); do
    echo "Creating resource group wth-team$i-rg"
    az group create --name wth-team$i-rg --location uksouth
    
    TEAM_UPN=wth-team$i@$DOMAIN

    echo "Creating team user $TEAM_UPN"
    az ad user create --display-name wth-team"$i"-user  --password $PASSWORD --user-principal-name "$TEAM_UPN"

    echo "Creating role assignment $TEAM_UPN"
    az role assignment create --assignee "$TEAM_UPN"  --role contributor --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/wth-team"$i"-rg

    echo "Creating service principal into ./AzureCredentials/principal-team$i.json"
    az ad sp create-for-rbac --name "wth-team$i" --role contributor \
                        --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/wth-team"$i"-rg \
                        --sdk-auth > ./AzureCredentials/principal-team"$i".json
done


# Make some directories to support the process and create one as a git repo
mkdir -p ResourcesRepo
git init ./ResourcesRepo

# Copy the files for the team repo into local git repo
cp -r $RESOURCE_DIR/ ./ResourcesRepo
cd ./ResourcesRepo

# Rename the master branch to main for those who don't have main as default branch name
# for those who have main as default branch name this will error but will not affect the script
git branch -m master main

# Add the files and commit
git add .
git commit -m "Initial commit"

# Create the team repos
for i in $(seq $GROUP_COUNT); do
    # Create a team repo
    echo "Creating team repo $ORGANISATION/wth-team$i"
    gh repo create $ORGANISATION/wth-team"$i" --public -y

    echo "Add the team$i repo as a remote and push the resources"
    git remote add team"$i" https://github.com/$ORGANISATION/wth-team"$i".git
    git push team"$i" main
done
cd ..

# create the shared teams repo (for credential distribution in issues)
echo "Creating team repo $ORGANISATION/wth-teams"
gh repo create $ORGANISATION/wth-teams --private -y
for i in $(seq $GROUP_COUNT); do
    echo "Creating issues for team $i"
    gh issue create -R $ORGANISATION/wth-teams -t "Azure Service Principal Credentials for Team $i" -F ./AzureCredentials/principal-team"$i".json
    
    # emit file here as CLI doesnt allow newline chars in issue body
    echo "User: wth-team$i@$DOMAIN\nPassword: $PASSWORD" > body
    gh issue create -R $ORGANISATION/wth-teams -t "Azure User Principal Credentials for Team $i" -F ./body
    rm body
done

# Create a team for each group so we centralise where we add permissions to hack teams
for i in $(seq $GROUP_COUNT); do
    echo "Creating Team for team $i"
    TEAMNAME=wth-team$i
    gh api --method POST -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/$ORGANISATION/teams -f name="$TEAMNAME" -f description='Hack group team' -f permission='push' -f privacy='closed' --silent

    echo "Adding team $i to their team repo (push rights)"
    gh api --method PUT -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/$ORGANISATION/teams/"$TEAMNAME"/repos/$ORGANISATION/"$TEAMNAME" -f permission='push' --silent

    echo "Adding team $i to the teams repo (pull only)"
    gh api --method PUT -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/$ORGANISATION/teams/"$TEAMNAME"/repos/$ORGANISATION/wth-teams -f permission='pull' --silent
done

echo "Done!"
