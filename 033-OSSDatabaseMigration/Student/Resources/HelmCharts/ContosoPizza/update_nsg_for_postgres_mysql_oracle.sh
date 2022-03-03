

# Change NSG firewall rule to restrict Postgres, Oracle and MySQL database from your client machine only. The first step is to find out your local client IP address. 

echo -e "\n This script restricts the access to your Postgres, Oracle, and MySQL database from your computer only.

 The variable myip will get the ip address of the shell environment where this script is running from - be it a cloud shell or your own computer.
 You can get your computer's IP adress by browsing to  https://ifconfig.me. So if the browser says it is 102.194.87.201, your myip=102.194.87.201/32. 
\n"

myip=`curl -s ifconfig.me`/32


# In this resource group, there is only one NSG. Change the value of the resource group, if required
export rg_nsg="OSSDBMigration"

export clusterName="ossdbmigration"

export nodeResourceGroup=$(az aks show -n $clusterName -g $rg_nsg --query nodeResourceGroup -o tsv)

export nsg_name=`az network nsg list  -g $nodeResourceGroup --query "[].name" -o tsv`

# For this NSG, there are two rules for connecting to Postgres and MySQL.

export pg_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-5432" | sed 's/"//g'`
export my_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-3306" | sed 's/"//g'`
export oracle_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-1521" | sed 's/"//g'`

# Update the rule to allow access to Postgres and MySQL only from your client ip address - "myip"
#echo -e "Using Resource Group $rg_nsg, NSG Name $nsg_name, Names $pg_nsg_rule_name, $my_nsg_rule_name, $or_nsg_rule_name, Source Address Prefixes $myip

az network nsg rule update -g $nodeResourceGroup --nsg-name $nsg_name --name $my_nsg_rule_name --source-address-prefixes $myip
az network nsg rule update -g $nodeResourceGroup --nsg-name $nsg_name --name $pg_nsg_rule_name --source-address-prefixes $myip
az network nsg rule update -g $nodeResourceGroup --nsg-name $nsg_name --name $oracle_nsg_rule_name --source-address-prefixes $myip
