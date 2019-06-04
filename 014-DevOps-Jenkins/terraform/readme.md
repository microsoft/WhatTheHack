# Terraform Challenge
Utilizing Terraform deploy the app on ACI

## Deploy the resource 
Replace the following values with your values
*    ***Your_subscription_id***<br>
    *  ***Your_client_id***<br>
    * ***Your_client_secret***<br>
    *  ***Your_tenant_id***<br>

```bash
docker run -e subscription_id="Your_subscription_id" \
-e client_id="Your_client_id" \
-e client_secret="Your_client_secret" \
-e tenant_id="Your_tenant_id"
 alihhussain/terraform:v1
```