## How to Build the Docker Images

Navigate to the agentic_application directory and run the following commands to build each Docker image


```bash
# Navigate to the agent application directory
cd agentic_application

# Create the base Docker image
docker build -t izzyacademy/confluent-hackathon:3.2.1 -t izzyacademy/confluent-hackathon:latest -f Dockerfile.base .

# Build the Docker image for the Inventory MCP service
docker build -t izzyacademy/inventory:3.2.1 -t izzyacademy/inventory:latest -f Dockerfile.inventory .

# Build the Docker image for the Replenishment MCP service
docker build -t izzyacademy/replenishment:3.2.1 -t izzyacademy/replenishment:latest -f Dockerfile.replenishment .

# Build the Docker image for the Employee Agent Experience
docker build -t izzyacademy/employee:3.2.1 -t izzyacademy/employee:latest -f Dockerfile.employee .

# Build the Docker image for the Supplier Agent Experience
docker build -t izzyacademy/supplier:3.2.1 -t izzyacademy/supplier:latest -f Dockerfile.supplier .


```

## How to Run the Dockers Containers with Docker Compose

These are the steps:

- Navigate to the compose directory
- ensure that the environment variables in the `shared_environment_variables.env` file are accurate
- make sure the `shared_environment_variables.env` file is in the current directory
- kick off the docker compose collection
- shut it down when you are done with you test/demo

```bash

# Navigate to the agent application directory
cd compose

# Run the compose file as follows
docker-compose up

# Tear down when you are done
docker-compose down --remove-orphans

```

### How to Log on to the Containers

```bash
# List all the active containers
docker ps


# Log into the employee container
docker exec -it compose-employee-1 /bin/bash

# Log into the supplier container
docker exec -it compose-supplier-1 /bin/bash

# Log into the customer container
docker exec -it compose-customer-1 /bin/bash

```

Once you are in the container, you can execute each agent as follows:

```bash

# this is the employee experience
uv run agent_employee_experience.py

# this is the supplier or vendor experience
uv run agent_supplier_experience.py

# this is for the customer experience to search SKUs, make purchases, return previous purchases
uv run agent_customer_experience.py

```