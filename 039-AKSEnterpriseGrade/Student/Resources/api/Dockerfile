FROM ubuntu:18.04
MAINTAINER Jose Moreno "jose.moreno@microsoft.com"

RUN apt-get update -y && apt-get install -y python3-pip python3-dev build-essential curl libssl1.0.0 libssl-dev libpq-dev
# See about installing ODBC drivers here: https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017
# Note that the driver version installed needs to match the version used in the code

# Ubuntu 18.04 (ODBC SQL driver 17.0)
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y --fix-missing
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev mssql-tools

COPY . /app
WORKDIR /app
RUN pip3 install -r requirements.txt
CMD ["sh", "-c", "python3 sql_api.py"]

EXPOSE 8080
