# This script will be invoked by the automation script that runs when a new VM instance is created in the VM Scale Set.

# Modify this script to add code that configures Datadog on the web servers running in the VM Scale Set

# Create a folder to let us know the script is running.
New-Item -Path 'C:\Datadog' -ItemType Directory