# Challenge 4: Application Gateway

[< Previous Challenge](./03-Asymmetric.md) - **[Home](README.md)** - [Next Challenge >](./05-PaaS.md)

## Notes and Guidance

* Whether placing the AppGW in the hub or the spokes is a design decision (whether the appgw is a central component shared across apps, or more app-specific)
* When configuring reaching multiple backends, participants have two options:
    * Advanced listeners, separating per Host. They can use different [nip.io](https://nip.io) FQDNs
    * Advanced rules, doing URL path matching. More complex, and it can break when each app has multiple paths
* For enabling SSL they can use self-signed certificates. Here an example of creating a self-signed certificate in Linux and PowerShell. This example creates a full-chain cert, so that you can use the intermediate CA cert for TLS inspection in the Azure Firewall, even if that is not a requirement:

```bash
# Create private root CA
openssl genrsa -out /tmp/rootCA.key 4096
openssl req -x509 -new -nodes -key /tmp/rootCA.key -sha256 -days 1024 -subj "/C=US/ST=WA/O=Contoso/CN=root.contoso.com" -out /tmp/rootCA.crt
# Create wildcard self-signed cert
openssl genrsa -out /tmp/contoso.com.key 2048
openssl req -new -sha256 -key /tmp/contoso.com.key -subj "/C=US/ST=WA/O=Contoso, Inc./CN=*.contoso.com" -out /tmp/contoso.com.csr
openssl x509 -req -in /tmp/contoso.com.csr -CA /tmp/rootCA.crt -CAkey /tmp/rootCA.key -CAcreateserial -out /tmp/contoso.com.crt -days 500 -sha256
# openssl req -new -newkey rsa:2048 -nodes -keyout ssl.key -out ssl.csr -subj "/C=US/ST=WA/L=Redmond/O=AppDev/OU=IT/CN=*.contoso.com"
# openssl x509 -req -days 365 -in ssl.csr -signkey ssl.key -out ssl.crt
cat /tmp/contoso.com.key /tmp/contoso.com.crt /tmp/rootCA.crt >/tmp/contoso.com.bundle.pem
cert_passphrase='Microsoft123!'
openssl pkcs12 -export -nodes -in /tmp/contoso.com.bundle.pem -out "/tmp/contoso.com.bundle.pfx" -passout "pass:$cert_passphrase"
# Add certs to App Gateway
az network application-gateway root-cert create -g $rg --gateway-name $appgw_name \
  --name contosoroot --cert-file /tmp/rootCA.crt
az network application-gateway ssl-cert create -g $rg --gateway-name $appgw_name -n contoso \
  --cert-file /tmp/contoso.com.bundle.pfx --cert-password $cert_passphrase
```

````PowerShell
#Create root cert
$params = @{
  DnsName = "root.contoso.com"
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-Date).AddYears(5)
  CertStoreLocation = 'Cert:\LocalMachine\My'
  KeyUsage = 'CertSign','CRLSign' #fixes invalid cert error
}
$rootCA = New-SelfSignedCertificate @params

#Create wildcard self-signed cert
$params = @{
  DnsName = "*.contoso.com"
  Signer = $rootCA
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-date).AddYears(2)
  CertStoreLocation = 'Cert:\LocalMachine\My'
}
$wildcardCert = New-SelfSignedCertificate @params

#Add self-signed root to trusted root cert store
Export-Certificate -Cert $rootCA -FilePath "C:\certs\rootCA.crt"
Import-Certificate -CertStoreLocation 'Cert:\LocalMachine\Root' -FilePath "C:\certs\rootCA.crt"

#Export the certificate to PFX
$cert_passphrase = (ConvertTo-SecureString -String 'password' -AsPlainText -Force)
Export-PfxCertificate -Cert $wildcardCert -FilePath 'C:\certs\wirldcardCert.pfx' -Password $cert_passphrase

# Add certs to App Gateway
az network application-gateway root-cert create -g $rg --gateway-name $appgw_name \
  --name contosoroot --cert-file "C:\certs\rootCA.crt"
az network application-gateway ssl-cert create -g $rg --gateway-name $appgw_name -n contoso \
  --cert-file 'C:\certs\wirldcardCert.pfx' --cert-password $cert_passphrase

````

## Advanced Challenges

- If the AzFW should inspect the traffic with end-to-end SSL, it needs to sit behind the AppGW with TLS inspection active (AzFW Premium)
- To configure TLS inspection in the firewall, you will need well-known certificates in the servers (at the time of this writing)
- When using URL matching rules, if the web site has subfolders the rules will easily break, try to show them that
