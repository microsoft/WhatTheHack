

# Change NSG firewall rule to restrict Postgres and MySQL database from client machine only

# Find out your local client ip address. 

echo " 

If you are running this script from Azure Cloud Shell, then you need to also run this on your local machine. Alternatively, you can point your browser to https://ifconfig.me

 "
myip=`curl ifconfig.me`/32


# In this resource group, there is only one NSG. Change the value of the resource group, if required

export rg_nsg="MC_OSSDBMigration_ossdbmigration_westus"
export nsg_name=`az network nsg list  -g $rg_nsg -o table | tail -1 | awk '{print $2}'`

# For this NSG, there are two rules for connecting to Postgres and MySQL.

export pg_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-5432" | sed 's/"//g'`
export my_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-3306" | sed 's/"//g'`

# Update the rule to allow access to Postgres and MySQL only from your client ip address - "myip"
   
az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $my_nsg_rule_name --source-address-prefixes $myip
az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $pg_nsg_rule_name --source-address-prefixes $myip
