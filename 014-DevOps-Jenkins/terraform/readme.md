# Terraform Challenge
Utilizing Terraform deploy the app on ACI

## Deploy the app 
1. Deploy the resource
<br>
Replace the following values with your values<br>
    * ***Your_subscription_id***
    *  ***Your_client_id***
    * ***Your_client_secret***
    *  ***Your_tenant_id***

```bash
docker run -e subscription_id="Your_subscription_id" \
-e client_id="Your_client_id" \
-e client_secret="Your_client_secret" \
-e tenant_id="Your_tenant_id"
 alihhussain/terraform:v1
```