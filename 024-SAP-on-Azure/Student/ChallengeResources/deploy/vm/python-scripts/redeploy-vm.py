'''
This script redeploys a VM that resides in the same azure space (i.e., resourrce group and VNet).
How to run:  python redeploy-vm.py <name of the vm to redeploy>
Example:  python redeploy-vm.py hanavm-1
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

    sched_event_url = "http://169.254.169.254/metadata/scheduledevents?api-version=2017-08-01"
    request2 = urllib2.Request(url=sched_event_url, headers=header)
    response = urllib2.urlopen(request2)
    sched_events_json = response.read()
    print(sched_events_json)

    subscription_id = os.environ.get('AZURE_SUBSCRIPTION_ID')
    credentials = ServicePrincipalCredentials(
            client_id=os.environ['AZURE_CLIENT_ID'],
            secret=os.environ['AZURE_SECRET'],
            tenant=os.environ['AZURE_TENANT']
        )

    compute_client = ComputeManagementClient(credentials, subscription_id)
    r_virtual_machine = compute_client.virtual_machines.get(
            GROUP_NAME,
            VM_NAME
        )

    async_vm_redeploy = compute_client.virtual_machines.redeploy(GROUP_NAME, VM_NAME)
    r_virtual_machine = async_vm_redeploy.result()


if __name__=="__main__":
   main()

