# Challenge 01 - Run the app

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

With this second challenge you will be able to run the "Rock Paper Scissors Boom" app locally.

![Run the app](../images/RunTheApp.png)

## Description

- Leveraging Docker & Docker Compose, build and run the app locally. You can use the `docker-compose.yaml` file in the `Resources.zip` file.
- Test the app as an end-user and play a game. You can reach the app via `localhost`.

## Success Criteria

To complete this challenge successfully, you should be able to:

1. Make sure `docker ps` is showing you 2 Docker containers running successfully.
1. In your web browser, navigate to the app and play a game, make sure it's working without any error.

## Learning Resources

- [SQL Server on Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-overview)
- [ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core)
- [Why Docker?](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Tips

- Look at the `docker-compose.yaml` file and set a password for the SQL Server container (it is referenced 3 places in the file)
- Run `docker compose up` from the folder where the `docker-compose.yaml` file is to build & run the Docker images locally.
