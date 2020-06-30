# Azure region to deploy resource in; please choose the same region as your storage from step 3 (example: "westus2")
az_region = "eastus2"

# Name of resource group to deploy (example: "demo1")
az_resource_group = "saplab"

# Unique domain name for easy VM access (example: "hana-on-azure1")
az_domain_name = "hana-on-azure1"

# Size of the VM to be deployed (example: "Standard_E8s_v3")
# For HANA platform edition, a minimum of 32 GB of RAM is recommended
vm_size = "Standard_E8s_v3"

# Path to the public SSH key to be used for authentication (e.g. "~/.ssh/id_rsa.pub")
sshkey_path_public = "~/.ssh/id_rsa.pub"

# Path to the corresponding private SSH key (e.g. "~/.ssh/id_rsa")
sshkey_path_private = "~/.ssh/id_rsa"

# OS user with sudo privileges to be deployed on VM (e.g. "demo")
vm_user = "demo"

# SAP system ID (SID) to be used for HANA installation (example: "HA1")
sap_sid = "HA1"

# SAP instance number to be used for HANA installation (example: "01")
sap_instancenum = "01"

# URL to download SAPCAR binary from (see step 6)
url_sap_sapcar_linux = "https://dswrepo.file.core.windows.net/sapswrepo/SAP_SW/SAPCAR 7.21/linux/SAPCAR_1211-80000935.EXE?sp=rl&st=2020-05-08T18:46:00Z&se=2020-05-09T18:46:00Z&sv=2019-10-10&sig=yOGadmUqKYFPsQFEMblAonr%2BZBFKE%2FR8w%2BUzSudPOC0%3D&sr=f"

# URL to download HANA DB server package from (see step 6)
url_sap_hdbserver = "https://dswrepo.file.core.windows.net/sapswrepo/SAP_SW/HANA2.0 SP03 Rev33/patch 37/IMDB_SERVER20_037_1-80002031.SAR?sp=rl&st=2020-05-08T18:47:51Z&se=2020-05-09T18:47:51Z&sv=2019-10-10&sig=aQio83TKl4mUXfpagiFqX%2BnmZQFbk71iNHuMfV%2BI%2B3U%3D&sr=f"

# Password for the OS sapadm user
pw_os_sapadm = "Abcd1234"

# Password for the OS <sid>adm user
pw_os_sidadm = "Abcd1234"

# Password for the DB SYSTEM user
# (In MDC installations, this will be for SYSTEMDB tenant only)
pw_db_system = "Abcd1234"

# Set this flag to true when installing HANA 2.0 (or false for HANA 1.0)
useHana2 = true

# Set this flag to true when installing the XSA application server
install_xsa = false

# Set this flag to true when installing SHINE demo content (requires XSA)
install_shine = false

# Set this flag to true when installing Cockpit (requires XSA)
install_cockpit = false

# Set this flag to true when installing WebIDE (requires XSA)
install_webide = false

# Set this to be a list of the ip addresses that should be allowed by the NSG.
allow_ips = ["0.0.0.0/0"]
