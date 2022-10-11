# Terraform solution to 039-AKS

Customize necessary variables:
```
cp tfvars .tfvars
vim .tfvars
```

Run Terraform:
```
terraform init -upgrade
terraform plan -var-file=.tfvars
terraform apply -var-file=.tfvars
```
