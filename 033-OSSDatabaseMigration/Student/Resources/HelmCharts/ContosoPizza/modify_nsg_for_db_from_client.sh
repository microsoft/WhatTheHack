

# Change NSG firewall rule to restrict Postgres and MySQL database from client machine only

# Find out your local client ip address. 

echo -e "\n This script restricts the access to your ""on-prem"" Postgres, Oracle and MySQL database from the shell where it is run from.
 It removes public access to the databases and adds your shell IP address as an source IP to connect from.
 If you are running this script from Azure Cloud Shell and want to add your computer's IP address as a source for Gui tools to connect to, 
 then you have to edit the variable my_ip below - put  your computer's IP address. 
 
 In order to find the public IP address of your computer ip address,  point a browser to  https://ifconfig.me  
 
 If this script is run again it appends your IP address to the current white listed source IP addresses. \n"

my_ip=`curl -s ifconfig.me`/32


# In this resource group, there is only one  NSG

export rg_nsg="MC_OSSDBMigration_ossdbmigration_westus"
export nsg_name=` az network nsg list  -g $rg_nsg --query "[].name" -o tsv`

# For this NSG, there are three rules for connecting to Postgres / MySQL / Oracle .

export pg_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query "[].[name]" -o tsv | grep "TCP-5432" `
export my_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query "[].[name]" -o tsv | grep "TCP-3306" `
export or_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query "[].[name]" -o tsv | grep "TCP-1521" `

# Capture the existing allowed_source_ip_address. 

existing_pg_source_ip_allowed=`az network nsg rule show  -g $rg_nsg --nsg-name $nsg_name --name $pg_nsg_rule_name --query "sourceAddressPrefix" -o tsv`
existing_my_source_ip_allowed=`az network nsg rule show  -g $rg_nsg --nsg-name $nsg_name --name $my_nsg_rule_name --query "sourceAddressPrefix" -o tsv`
existing_or_source_ip_allowed=`az network nsg rule show  -g $rg_nsg --nsg-name $nsg_name --name $or_nsg_rule_name --query "sourceAddressPrefix" -o tsv`



# If it says "Internet" we treat it as 0.0.0.0

if [ "$existing_my_source_ip_allowed" = "Internet" ]
then
  existing_my_source_ip_allowed="0.0.0.0"
fi


if [ "$existing_pg_source_ip_allowed" = "Internet" ]
then
   existing_pg_source_ip_allowed="0.0.0.0"
fi


if [ "$existing_or_source_ip_allowed" = "Internet" ]
then
   existing_or_source_ip_allowed="0.0.0.0"
fi

# if the existing source ip allowed is open to the world - then we need to remove it first. Otherwise it is a ( list of ) IP addresses then 
# we append to it another IP address. Open the world is 0.0.0.0 or 0.0.0.0/0. 


existing_pg_source_ip_allowed_prefix=`echo $existing_pg_source_ip_allowed | cut  -d "/" -f1`
existing_my_source_ip_allowed_prefix=`echo $existing_my_source_ip_allowed | cut  -d "/" -f1`
existing_or_source_ip_allowed_prefix=`echo $existing_or_source_ip_allowed | cut  -d "/" -f1`


# If it was open to public, we take off the existing 0.0.0.0 or else we append to it.



if [ "$existing_pg_source_ip_allowed_prefix" = "0.0.0.0" ]  
then  
  new_pg_source_ip_allowed="$my_ip"
else  
  new_pg_source_ip_allowed="$existing_pg_source_ip_allowed $my_ip"
fi


if [ "$existing_my_source_ip_allowed_prefix" = "0.0.0.0" ]  
then  
  new_my_source_ip_allowed="$my_ip"
else  
  new_my_source_ip_allowed="$existing_my_source_ip_allowed $my_ip"
fi


if [ "$existing_or_source_ip_allowed_prefix" = "0.0.0.0" ]  
then  
  new_or_source_ip_allowed="$my_ip"
else  
  new_or_source_ip_allowed="$existing_or_source_ip_allowed $my_ip"
fi


# Update the rule to allow access to Postgres and MySQL only from your client ip address - "myip". Also discard errors - as if you run the script
# simply twice back to back - it gives an error message - does not do any harm though .
   

#echo -e "Using Resource Group $rg_nsg, NSG Name $nsg_name, Names $pg_nsg_rule_name, $my_nsg_rule_name, $or_nsg_rule_name, Source Address Prefixes $new_pg_source_ip_allowed"
az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $pg_nsg_rule_name --source-address-prefixes $new_pg_source_ip_allowed 2>/dev/zero

if [ $? -ne 0 ]
then
  echo -e "\n Your Postgres Firewall rule was not changed. It is possible that you already have $my_ip white listed \n"
fi

az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $my_nsg_rule_name --source-address-prefixes $new_my_source_ip_allowed 2>/dev/zero

if [ $? -ne 0 ]
then
  echo -e "\n Your MySQL Firewall rule was not changed. It is possible that you already have $my_ip white listed \n"
fi

az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $or_nsg_rule_name --source-address-prefixes $new_or_source_ip_allowed 2>/dev/zero

if [ $? -ne 0 ]
then
  echo -e "\n Your Oracle Firewall rule was not changed. It is possible that you already have $my_ip white listed \n"
fi


