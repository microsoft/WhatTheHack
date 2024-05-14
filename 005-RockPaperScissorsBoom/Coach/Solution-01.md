# Challenge 01 - Run the app - Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

1.  Navigate to the `Resources` directory.

1.  In the `docker-compose.yaml` file, update the password for the SQL Server & the connection string for the database in the web app.

    - There are 3 places in the Docker Compose file where you need to update the password for the SQL Server
      - The environment variables for the database container
      - The health check for the database container
      - The environment variables for the web app container

1.  Run the following command to build & run the application & database.

    ```shell
    docker compose up --build -d
    ```

1.  Run the following command to check and see if the 2 Docker images (application & database) are running successfully.

    ```shell
    docker ps
    ```

    You should see something like this:

    ```shell
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED          STATUS          PORTS                    NAMES
    396c8e105616   rpsb-rockpaperscissors-server                "dotnet RockPaperSci…"   19 minutes ago   Up 19 minutes   0.0.0.0:80->80/tcp       rockpaperscissors-server
    9f5ab21008de   mcr.microsoft.com/mssql/server:2022-latest   "/opt/mssql/bin/perm…"   40 minutes ago   Up 40 minutes   0.0.0.0:1433->1433/tcp   rockpaperscissors-sql
    ```

1.  Navigate to `http://localhost` in your browser.

1.  Play a game of Rock Paper Scissors Boom (click on the **Run the Game** link at the top of the page & click the **Run the Game** button).

    > NOTE: The following pages will result in an error since Azure AD B2C authentication has not been set up yet:
    >
    > 1. Sign In
    > 1. Competitors -> Create New
    > 1. Competitors -> <any-player-name> -> Edit | Delete

## Troubleshooting

- Make sure the students have the latest versions of Docker & Docker Compose installed on their machines.
  - Docker: `docker --version`
  - Docker Compose: `docker compose version`
