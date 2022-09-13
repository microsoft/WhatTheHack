

# Change NSG firewall rule to restrict Postgres and MySQL database from client machine only. The first step - to find out your local client ip address. 

echo -e "\n This script restricts the access to your Postgres and MySQL database from your computer only.

 The variable myip will get the ip address of the shell environment where this script is running from - be it a cloud shell or your own computer.
 You can get  your computer's IP adress by browsing to  https://ifconfig.me. So if the browser says it is 102.194.87.201, your myip=102.194.87.201/32. 
\n"

myip=`curl -s ifconfig.me`/32


# In this resource group, there is only one NSG. Change the value of the resource group, if required

export rg_nsg="MC_OSSDBMigration_ossdbmigration_westus"
export nsg_name=`az network nsg list  -g $rg_nsg --query "[].name" -o tsv`

# For this NSG, there are two rules for connecting to Postgres and MySQL.

export pg_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-5432" | sed 's/"//g'`
export my_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-3306" | sed 's/"//g'`

# Update the rule to allow access to Postgres and MySQL only from your client ip address - "myip"
   
az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $my_nsg_rule_name --source-address-prefixes $myip
az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $pg_nsg_rule_name --source-address-prefixes $myip
