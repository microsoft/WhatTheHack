from __future__ import annotations

from pydantic_graph import End, Graph

from contoso_retail_application import ReturnsDao, PurchasesDao, CustomerDependency, CustomerTransactionState, \
    StartNode, MainMenu, FinishNode, ShopInventory, ReturnPriorPurchase, BrowseInventory, FinalizeShopping, \
    FinalizeReturns


async def main():
    r_dao = ReturnsDao()
    p_dao = PurchasesDao()

    # Setting up the initial state and graph dependencies
    transaction_dependency = CustomerDependency(purchases_dao=p_dao, returns_dao=r_dao)
    transaction_state = CustomerTransactionState()

    # Listing all possible nodes within our state machine
    graph_nodes = (StartNode, MainMenu, FinishNode, ReturnPriorPurchase, ShopInventory, BrowseInventory, FinalizeShopping, FinalizeReturns)

    # Constructing the Graph object with all the nodes
    customer_experience_graph = Graph(nodes=graph_nodes, name="Customer Experience", state_type=CustomerTransactionState)

    # Setting the start node, initial state and graph dependencies
    async with customer_experience_graph.iter(start_node=StartNode(), state=transaction_state, deps=transaction_dependency) as run:
        current_node = run.next_node
        while not isinstance(current_node, End):
            print('Node', current_node)
            current_node = await run.next(current_node)

if __name__ == '__main__':
    import asyncio
    asyncio.run(main())