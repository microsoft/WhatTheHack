Please note that the script uses the *jq* module. The Azure Cloud Shell has that module installed, however if customers decide to use a linux box or WSL, they have to install it since this is a tool to parse the Jason output from the VPN status.
- sudo apt-get install jq

The script you will be running will create the following

- Hub and Spoke Topology 
- No On Premises environment will be deployed. That will be done on Challenge 1
- Local Network Gateway will have to be done later since we do not have the "On Premises" components at this stage.
- Script has parameters to imput Username and Password. 
- No Route Server or Central NVA will be deployed yet. 
