---
page_type: sample
languages:
- nodejs
products:
- nodejs
description: "This code is part of the Microsoft Learn module of the AKS workshop. It provides the API for the ratings application. The API connects to a MongoDB to store and retrieve data. WTH NOTE: We will be deploying a MongoDB in challenge 4 and learning how to connect to a MongoDB in challenge 5!"
urlFragment: "aksworkshop-ratings-api"
---

# AKS Workshop - ratings-api sample code

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

This code is part of the Microsoft Learn module of the AKS workshop. It provides the API for the ratings application. The API connects to a MongoDB to store and retrieve data. WTH NOTE: We will be deploying a MongoDB in challenge 4 and learning how to connect to a MongoDB in challenge 5!

## Contents

| File/folder       | Description                                |
|-------------------|--------------------------------------------|
| `routes`          | API endpoint implementation.               |
| `models`          | Representation of API data model.          |
| `data`            | Data to be preloaded into the database.    |
| `views`           | Handelbars HTML view templates.            |
| `server.js`       | NodeJS web server startup file.            |
| `app.js`          | Express NodeJS application startup file.   |
| `.gitignore`      | Define what to ignore at commit time.      |
| `.dockerignore`   | Define what to ignore at build time.       |
| `Dockerfile`      | Define how the Docker image is built.      |
| `README.md`       | This README file.                          |
| `LICENSE`         | The license for the sample.                |

## Prerequisites

To build this sample locally, you can either build using Docker, or using NPM.

- Install [Docker](https://www.docker.com/get-started)
- Install [NodeJS](https://nodejs.org/en/download/)

## Setup

- To build using Docker, in the project folder, run `docker build -t ratings-api .`
- To build using NPM, in the project folder, run `npm install`

## Running the sample

- To run using Docker, run `docker run -it -p 3000:3000 ratings-api`
- To run using NPM, run `npm start`

The API exposes port 3000.

You should then be able to access the API at <http://localhost:3000/api/items>

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
