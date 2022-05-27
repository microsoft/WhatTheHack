# Challenge 01 - Create a Linux Virtual Machine - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance
 
To accomplish the creation of the Ubuntu 20.04 Linux Virtual Machine, you can follow the below steps using the Azure CLI from cloud shell:

- Create the resource group:

```bash
az group create --name rg-linux-fundamentals --location eastus
```

- Create the Virtual Machine

```bash
az vm create \
  --resource-group rg-linux-fundamentals \
  --name myVM \
  --image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
  --admin-username student \
  --generate-ssh-keys
```

- Connect to virtual machine

```bash
ssh student@[public-ip]
```


