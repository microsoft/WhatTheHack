# Use the official Microsoft Python Dev Container image
FROM mcr.microsoft.com/devcontainers/python:3.11
 
# Install any additional dependencies
RUN apt-get update && apt-get install -y \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*
 
# Install Azure CLI and Bicep
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    az bicep install
 
# Set the working directory
WORKDIR /workspace
 
# Copy the current directory contents into the container
COPY . /workspace
 
# Install Python dependencies if requirements.txt exists
RUN if [ -f "requirements.txt" ]; then pip install -r requirements.txt; fi