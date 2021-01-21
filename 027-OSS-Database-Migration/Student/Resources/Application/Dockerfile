FROM ubuntu:18.04

# Set default environment variables here
ENV APP_BRAINTREE_MERCHANT_ID=1 \
    APP_BRAINTREE_PUBLIC_KEY=1 \
    APP_BRAINTREE_PRIVATE_KEY=1 \
    APP_RECAPTCHA_PUBLIC_KEY=1 \
    APP_RECAPTCHA_PRIVATE_KEY=1 \
    APP_DATASOURCE_DRIVER=1 \
    APP_DATASOURCE_URL=1 \
    APP_DATASOURCE_USERNAME=1 \
    APP_DATASOURCE_PASSWORD=1 \
    APP_HIBERNATE_DIALECT=1 \
    APP_HIBERNATE_HBM2DDL_AUTO=1\
    APP_PORT=hello \
    APP_CONTEXT_PATH=2

# Install all the dependencies we need
RUN apt-get update
RUN apt-get -y install nodejs npm openjdk-8-jdk
RUN apt-get -y purge openjdk-11-jre-headless
RUN mkdir -p /usr/local/pizzeria

# Set the working directory
WORKDIR /usr/local/pizzeria

# Copy all our app jars and artifacts created from mvn clean package
COPY . /usr/local/pizzeria

# Make our entrypoint script executable
RUN chmod 0755 start-pizza-app.sh

# Expose port 8081
EXPOSE 8081

ENTRYPOINT ["/usr/local/pizzeria/start-pizza-app.sh"]
