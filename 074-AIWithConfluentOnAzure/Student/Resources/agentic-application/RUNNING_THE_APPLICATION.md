## Setting up the Virtual Environment

Run the following command from the `agentic_application` folder to create the virtual environment:

```bash

uv venv

```

## Activating the Virtual Environment

You can run these commands to activiate the virtual environment

### On Mac OS X or Linux

```bash

source .venv/bin/activate

```

### On Windows

```bash

# If you are using Powershell
.venv\Scripts\Activate.ps1

# If you are using the Command Pallete
.venv\Scripts\activate.bat

```

## Loading your Environment Variables

Run the following command to load the environment variables before running the agents

```bash

source .env.sh

```

## Running the MCP Servers

You can run these commands to start up the MCP servers for the applications

Make sure to `use a dedicated tab` for each service

```bash
uv run mcp_service.py --service inventory --port 8080

uv run mcp_service.py --service replenishment --port 8081

uv run mcp_service.py --service shopping --port 8082

```

### Debugging the MCP Servers

If you are having trouble or need to validate the MCP servers before running the agents you can use this tool below

```bash
npx @modelcontextprotocol/inspector
```

### Running the Agent Experiences

You can run these commands after the MCP servers have booted up:

Make sure you use `a dedicated tab` for each experience

````bash

# this is the employee experience
uv run agent_employee_experience.py

# this is the supplier or vendor experience
uv run agent_supplier_experience.py

# this is for the customer experience to search SKUs, make purchases, return previous purchases
uv run agent_customer_experience.py

````


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