# Challenge 4: Application Gateway

[< Previous Challenge](./03-Asymmetric.md) - **[Home](README.md)** - [Next Challenge >](./05-PaaS.md)

## Introduction

In this challenging you will integrate an Application Gateway in the design.

## Description

* Whether placing the AppGW in the hub or the spokes is a design decision (whether the appgw is a central component shared across apps, or more app-specific)
* When configuring reaching multiple backends, participants have two options:
    * Advanced listeners, separating per Host. They can use different [nip.io](https://nip.io) FQDNs
    * Advanced rules, doing URL path matching. More complex, and it can break when each app has multiple paths
* For enabling SSL they can use self-signed certificates. Here an example of creating a self-signed certificate in Linux. This example creates a full-chain cert, so that you can use the intermediate CA cert for TLS inspection in the Azure Firewall, even if that is not a requirement:

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

## Additional optional challenges

* You can challenge participants to place the AppGW in front or behind the AzFW, and discuss pros/cons
* You can challenge participants to add more sophisticated rules, such as URL matching or header manipulation
* You can add the objectives to include SSL and WAF. For SSL you can use self-signed certificates
