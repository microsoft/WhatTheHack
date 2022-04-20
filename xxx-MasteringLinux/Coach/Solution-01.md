# Challenge 01 - Mastering Linux - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance
 
To accomplish the creation of the Ubuntu Linux Virtual Machine, you can follow the below steps using the Azure CLI from cloud shell:

- Create the resource group:

```bash
az group create --name rg-mastering-linux --location eastus
```

- Create the Virtual Machine

```bash
az vm create \
  --resource-group rg-mastering-linux \
  --name myVM \
  --image UbuntuLTS \
  --admin-username student \
  --generate-ssh-keys
```

- Connect to virtual machine

```bash
ssh student@[public-ip]
```


