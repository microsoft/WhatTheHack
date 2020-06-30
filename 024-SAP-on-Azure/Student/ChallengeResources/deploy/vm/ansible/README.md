# n+m scale out scenario

## How to deploy n+m scale out HANA cluster:

Example:
```python
ansible-playbook create_n_m_hana_cluster.yml --extra-vars="{resource_group: "resourcegroupname", ssh_private_key_file: "/tmp/sshkey", ssh_public_key_file: "/tmp/sshkey.pub", vm_user: "azureuser", allowed_source_ip_prefix: "X.X.X.X/24", n: 2, m:0, az_domain_name: "mydomain"}"
```
input parameters:
```python
resource_group: name of the azure resource group to be created
ssh_private_key_file: the ssh key for the VM configuration
ssh_public_key_file: the ssh key for the VM configuration
vm_user: user to be created for the VMs
allowed_source_ip_prefix: The source ip addresses that are allowed to access (Access Control List)
n: number of worker VMs to create
m: number of standby VMs to create
az_domain_name: prefix to use for the domain name of the VMs. The domain name can not have upper case or special characters except '-'
```

## Failover case: 1) Migrate the disks from the failed VM to a standby VM. 2) Move the standby VM behind the load balancer the failed VM is attached to
Command:
```python
ansible-playbook migrate_standby_to_worker.yml --extra-vars="{resource_group: "resource_group", migrate_to_vm: "name-standby-vm", decommission_vm: "name-failed-hana-vm" }"
```
