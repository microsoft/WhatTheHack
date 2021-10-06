# Challenge 2: Discovery and Assessment

[< Previous Challenge](./01-design.md) - **[Home](../README.md)** - [Next Challenge >](./03-prepare.md)

## Description

Assess the on-premises digital estate. Here some information about the nested VMs you will find in the simulated environment:

- smarthotelweb1 (192.168.0.4): web tier (IIS)
- smarthotelweb2 (192.168.0.5): application tier (IIS)
- smarthotelsql1 (192.168.6): database tier (SQL Server). Inbound traffic on port 1433 on the host VM is forwarded to this VM
- UbuntuWAF (192.168.8): nginx reverse proxy. Inbound traffic on port 80 on host VM is forwarded to this VM. It then forwards traffic to the web tier (smarthotelweb1)

Credentials to all Windows machines are `Administrator`/`demo!pass123`. For the Ubuntu VM, it is `demouser`/`demo!pass123`.

## Success Criteria

- An assessment of the on-premises digital estate has been performed:
    - Migration readiness to Azure IaaS has been evaluated
    - A cost estimation has been performed
    - Application dependencies have been discovered
- An Azure landing zone has been created (it might have been pre-created for you before the exercise)

## Learning Resources

- [Asses Hyper-V VMs for migration to Azure](https://docs.microsoft.com/azure/migrate/tutorial-assess-hyper-v)
- [Setup agent-based dependency visualization](https://docs.microsoft.com/azure/migrate/how-to-create-group-machine-dependencies)
- [Create Virtual Network in Azure Portal](https://docs.microsoft.com/azure/virtual-network/quick-create-portal)
