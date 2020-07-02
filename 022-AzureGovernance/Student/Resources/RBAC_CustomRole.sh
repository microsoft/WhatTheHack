#Create custom Role
az role definition create --role-definition ./rgcreator.json

#List the new custom role
az role definition list --name "Contributor"

#Delete Custom Role
az role definition delete --name "Resource Group Creator"