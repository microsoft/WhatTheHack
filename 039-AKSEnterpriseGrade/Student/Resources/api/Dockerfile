FROM ubuntu:24.04
LABEL maintainer="Jose Moreno <jose.moreno@microsoft.com>"

# Install ODBC Driver 18 from the Microsoft Ubuntu 24.04 repository.
# https://learn.microsoft.com/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
RUN apt-get update && apt-get install -y --no-install-recommends \
	python3 python3-flask python3-dnspython python3-requests python3-pymysql \
	python3-pyodbc python3-psycopg2 curl ca-certificates \
	&& curl -fsSLo /tmp/packages-microsoft-prod.deb \
		https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb \
	&& dpkg -i /tmp/packages-microsoft-prod.deb \
	&& apt-get update \
	&& ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 unixodbc-dev mssql-tools18 \
	&& rm -rf /var/lib/apt/lists/* /tmp/packages-microsoft-prod.deb

WORKDIR /app
COPY . .

CMD ["python3", "sql_api.py"]

EXPOSE 8080
