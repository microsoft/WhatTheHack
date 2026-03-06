
We need to do the following
- define Pydantic Objects for all the schemas
- Department
- Product
- ShoppingCartItem
- ShoppingCart



- we need to set up AI Search INDEX for departments and products (SKU and PRICING)


### Customers
Customers of the grocery company
- angela@contosocustomers.ai
- patrick@contosocustomers.ai
- darcy@contosovendors.ai
- mikhail@contosogroceries.ai
- jacob@contosogroceries.ai

### Employees
Employees of the Grocery company
- james@contosogroceries.ai
- charlotte@contosogroceries.ai
- andy@contosogroceries.ai
- juan@contosogroceries.ai
- jason@contosogroceries.ai
- devanshi@contosogroceries.ai

### Vendors
Global can supply anything but the rest only focus on one department
- kroger@contosovendors.ai
- costco@contosovendors.ai
- global@contosovendors.ai

## Activate the Virtual Environment

```bash
source .env.sh
source .venv/bin/activate
```

# Run the MCP Services

````bash
uv run mcp_service.py --service inventory --port 8080

uv run mcp_service.py --service replenishment --port 8081

uv run mcp_service.py --service shopping --port 8082
````


# Run the Agents

````bash

uv run agent_employee_experience.py

uv run agent_supplier_experience.py

uv run agent_customer_experience.py

````

### Run the MCP Inspector

npx @modelcontextprotocol/inspector


### Network Debugging Tools

```bash

apt-get install -y iputils-ping telnet vim

```



### Testing Nodes

- Customer ID: jacob@contosogroceries.ai
- Receipt ID: 100001