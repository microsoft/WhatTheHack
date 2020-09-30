# Notes for Challenge 4 - Offload traffic for a high traffic event

 [< Previous Challenge [3]](./Solution03.md) - **[Home](./README.md)** - [Next Challenge [5] >](./Solution05.md)

At the start of Challenge 3, the student's Front Door instance should look like:
- 1 Custom Domain with WAF
- 1 Backend Pool that points to the App Service (the Backend Host Name ends with **azurewebsites.net** in the Azure Front Door designer)
- 1 Routing Rule, that sends all HTTP and HTTPS traffic to the one Backend Pool

What it needs to evolve to:
- 1 Custom Domain with WAF
- 2 Backend Pools
  1. One that points to the App Service (the Backend Host Name ends with **azurewebsites.net**) - For example named "AppService"
  2. One that points to the FQDN of the Static Website created from the Azure Storage Account (the Backend Host Name ends with **web.core.windows.net** in the Azure Front Door designer) - For example named "MessageOnly"
- 2 Routing Rules (they get processed in order)
  1. Routing Rule that sends all HTTP/HTTPS Traffic:
     - Patterns to Match (1)
       - `/Message`
     - Routing Type: Forward
     - Backend Pool = 2nd (MessageOnly)
  2. Routing Rule that sends all HTTP/HTTPS Traffic:
     - Patterns to Match (1)
       - `/*`
     - Routing Type: Forward
     - Backend Pool = 1st (AppService)     


## Links
[Static Web Site hosting](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website) - This is step for step of what is needed, with the exception of uploading the folder.

