# Challenge 1 - Head in the cloud, feet on the ground

[< Previous Challenge](./challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./challenge-01.md)

## Introduction

The Spring Boot application uses JPA and supports both in memory databases as well as MySQL. In this challenge we'll put our database on Azure while the code is running locally. Taking baby steps :)

## Description

Create a MySQL database on Azure and make sure that the application (running locally) can connect to it without changing any code.

## Success Criteria

1. Verify the application is working by creating a new owner, a new pet and a new visit
1. Connect to the database through a `mysql` client
1. Verify that the tables include the newly created entities (owner/pet/visit)
1. No files should be modified for this challenge

## Learning Resources

- https://docs.microsoft.com/en-us/azure/mysql/

## Tips

[Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) includes a bunch of various tools, including a `mysql` client.

And note that you can also pass configuration information to Spring Boot through [environment variables](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config).

[Next Challenge - Azure App Services :heart: Spring Boot >](./challenge-02.md)
