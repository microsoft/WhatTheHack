Failover test for HA pair
---------------------------
This test is performed on a HA pair of HANA instances. The database connection tests are run on a jumpbox VM (i.e., a bastion host).

This test:
 Tests the db connection via vip
 Stops HDB on the primary node
 Makes sure the secondary is promoted to primary
 Makes sure HDB is up in both the new primary and secondary
 Tests the db connection via vip again

Input parameters:
----------------
```
db_host: VIP of the DB host
db_host_port: Port
db_user: User name to connect to the SYSTEMDB
db_pwd: Password for the SYSTEMDB user
primary_hdb: Hostname of the primary HANA DB VM
secondary_hdb: Hostname of the secondary HANA DB VM
jumpbox_vm: IP or hostname of the bastion host from where the connection test will be done
sap_sid: SID of the HANA system
ansible_become_pass: Password for the SID user
instance_num: Instance number of the HANA system
primary_hdb_ip: Public IP or domain name of the primary HANA DB VM
```

Command:
--------
Example command:
```sh
 ansible-playbook playbook_failover_test.yml --extra-vars="{ db_host_name: "W.W.W.W", db_host_port: "99999", "db_user": "SYSTEM", db_pwd: "<Password>", primary_hdb: "hdb0", secondary_hdb: "hdb1", jumpbox_vm: "X.X.X.X", sap_sid: "SID1", ansible_become_pass: "<password>", instance_num: \"02\", primary_hdb_ip: "Y.Y.Y.Y" }" --private-key "/tmp/sshkey"
```
