# Azure region to deploy resource in; please choose the same region as your storage from step 3 (example: "westus2")
az_region = "eastus2"

# Name of resource group to deploy (example: "demo1")
az_resource_group = "hanapoc"

# Unique domain name for easy VM access (example: "hana-on-azure1")
az_domain_name = "hanaonazure"

# Size of the VM to be deployed (example: "Standard_E8s_v3")
# For HANA platform edition, a minimum of 32 GB of RAM is recommended
vm_size = "Standard_E32s_v3" # Standard_M64s

# Path to the public SSH key to be used for authentication (e.g. "~/.ssh/id_rsa.pub")
sshkey_path_public = "~/.ssh/id_rsa.pub"

# Path to the corresponding private SSH key (e.g. "~/.ssh/id_rsa")
sshkey_path_private = "~/.ssh/id_rsa"

# OS user with sudo privileges to be deployed on VM (e.g. "demo")
vm_user = "demo"

# OS user password
vm_paswd = " "

# SAP system ID (SID) to be used for HANA installation (example: "HN1")
sap_sid = "HDP"

# SAP instance number to be used for HANA installation (example: "01")
sap_instancenum = "01"

# URL to download SAPCAR binary from (see step 6)
url_sap_sapcar_linux = "https://XXX"

# URL to download HANA DB server package from (see step 6)
url_sap_hdbserver = "https://XXX"

#Flag that determines whether to install Cockpit on the host
install_cockpit = "false"

#Hana cockpit installer download link
url_cockpit = " "

# Password for the OS sapadm user
pw_os_sapadm = "XXX"

# Password for the OS <sid>adm user
pw_os_sidadm = "XXX"

# Password for the DB SYSTEM user
# (In MDC installations, this will be for SYSTEMDB tenant only)
pw_db_system = "XXX"

# Password for the DB SYSTEM user for the tenant DB (MDC installations only)
pwd_db_tenant = "XXX"

# Set this flag to true when installing HANA 2.0 (or false for HANA 1.0)
useHana2 = "true"

# Set this to be a list of the ip addresses that should be allowed by the NSG.
allow_ips = ["0.0.0.0/0"]

#Windows Bastion setup
windows_bastion = "true"
bastion_username_windows = "bastion_user"
pw_bastion_windows = ""
url_hana_studio_windows = ""
url_sapcar_windows = ""



