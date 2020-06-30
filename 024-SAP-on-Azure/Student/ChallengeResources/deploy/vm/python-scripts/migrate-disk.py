'''
This script detaches the disks from a (failed) node and attaches to another (standby).

To Run the script:
 Command: python migrate-disk.py <migrate_from_vm> <migrate_to_vm>
 Example: python migrate-disk.py hana-vm-1 hana-vm-2
'''

import os
import json
import sys
import urllib2
import copy
import socket

from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.compute import ComputeManagementClient

def main():
    mdUrl = "http://169.254.169.254/metadata/instance/compute?api-version=2017-08-01"
    header={'Metadata': 'True'}
    request = urllib2.Request(url=mdUrl, headers=header) 
    response = urllib2.urlopen(request)
    data = response.read()
    metaData = data.decode("utf-8")
    vm_meta_json = json.loads(metaData)
    print(vm_meta_json)
    GROUP_NAME = vm_meta_json["resourceGroupName"]
    VM_NAME = sys.argv[1]

    subscription_id = os.environ.get('AZURE_SUBSCRIPTION_ID')
    credentials = ServicePrincipalCredentials(
            client_id=os.environ['AZURE_CLIENT_ID'],
            secret=os.environ['AZURE_SECRET'],
            tenant=os.environ['AZURE_TENANT']
        )

    compute_client = ComputeManagementClient(credentials, subscription_id)
    failed_virtual_machine = compute_client.virtual_machines.get(
            GROUP_NAME,
            VM_NAME
        )

    data_disks = failed_virtual_machine.storage_profile.data_disks
    data_disks_r = copy.deepcopy(data_disks)
    data_disks[:] = []
    async_vm_update = compute_client.virtual_machines.create_or_update(GROUP_NAME, VM_NAME, failed_virtual_machine)
    failed_virtual_machine = async_vm_update.result()


    for disk_r in data_disks_r:
       print(disk_r)

    current_host = sys.argv[2]
    async_vm_update = compute_client.virtual_machines.create_or_update(GROUP_NAME, current_host, 
           {
             'location': vm_meta_json["location"],
             'storage_profile': {
                 'data_disks': data_disks_r
           }

        })

    async_vm_update.wait()

if __name__=="__main__":
   main()
