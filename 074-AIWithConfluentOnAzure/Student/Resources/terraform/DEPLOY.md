# Azure Resource Provisioning

This guide shows you how to set up the Azure Resources using Terraform

### 1. **Install Terraform**

- If you haven’t installed Terraform yet, install it:
  
  ```bash
        # (on MacOS with Homebrew)

        # Configure connection to the repo
        brew tap hashicorp/tap

        # Install the latest version of Terraform CLi
        brew install hashicorp/tap/terraform

  ```
  or
  [Download Terraform manually](https://developer.hashicorp.com/terraform/downloads).

---

### 2. **Authenticate to Azure**

You must be logged into Azure so Terraform can create the resources for you.

Run:

```bash

az login

```
- This will open a browser to authenticate.
- If you have multiple Azure subscriptions, you might also need:
 
  ```bash
  # Display your Azure Subscriptions
  az account list

  # Specify the Azure Subscription you are using for the Automation
  az account set --subscription "your-subscription-id"

  # Specifiy the Subscription in the Environment Variable for Terraform
  ARM_SUBSCRIPTION_ID="your-subscription-id"
  ```

---

### 3. **Initialize Terraform**

Inside the folder where you have your `main.tf`:

```bash

terraform init

```
- This downloads the **Azure Provider** and sets up your working directory.

---

### 4. **(Optional) Review What Terraform Will Do**

See what Terraform *plans* to create:

```bash

terraform plan

```
- It checks your script and shows you exactly what it will create **without** making changes yet.
- Always a good practice before applying.

---

### 5. **Apply Terraform to Create Resources**

Now **provision** the resources:

```bash

terraform apply

```

- Terraform will show you a detailed list of all resources it will create.
- Type **`yes`** when prompted to approve.

🌟 After a few minutes, Cosmos DB, Azure AI Search, Storage Account, and Redis Cache will be created in your Azure account!

---

### 6. **Outputs**

If you included the `output` blocks (like I did in the Terraform file earlier), after `apply`, Terraform will print the important connection details:

✅ Cosmos DB endpoint  
✅ Storage account blob URL  
✅ Redis hostname and access key  
✅ Azure Search keys  

You can copy this and keep them save for later. These will be needed to provision the Confluent Cloud Resources.

---

### Quick Recap
| Step              | Command                                   |
|-------------------|-------------------------------------------|
| Authenticate to Azure | `az login` |
| Initialize Terraform | `terraform init` |
| Plan (Preview)         | `terraform plan` |
| Apply (Provision)       | `terraform apply` |

---

### **Destroy the resources when you are done **
If you ever want to delete everything created by the script:

```bash
terraform destroy
```
(Also prompts you for confirmation.)

---