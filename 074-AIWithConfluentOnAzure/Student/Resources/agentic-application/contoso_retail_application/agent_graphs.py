from __future__ import annotations

from dataclasses import dataclass

from pydantic_graph import BaseNode, GraphRunContext, End
from rich.prompt import Prompt, IntPrompt

from .models import SkuId
from .data_access_objects import ReturnsDao, PurchasesDao
from .static_dataset import StaticDataset


@dataclass
class CustomerDependency:
    returns_dao: ReturnsDao
    purchases_dao: PurchasesDao

@dataclass
class CustomerTransactionState:
    customer_id: str | None = None
    active_return_cart: bool = False
    active_shopping_cart: bool = False
    shopping_cart_id: str | None = None
    receipt_id: str | None = None
    return_cart_id: str | None = None

@dataclass
class FinalizeReturns(BaseNode[CustomerTransactionState]):
    async def run(self, ctx: GraphRunContext[CustomerTransactionState]) -> FinishNode | ReturnPriorPurchase:
        pass

@dataclass
class FinalizeShopping(BaseNode[CustomerTransactionState]):
    async def run(self, ctx: GraphRunContext[CustomerTransactionState]) -> FinishNode | ShopInventory:
        pass

@dataclass
class BrowseInventory(BaseNode[CustomerTransactionState, CustomerDependency]):
    async def run(self, ctx: GraphRunContext[CustomerTransactionState, CustomerDependency]) -> MainMenu | ShopInventory:
        pass


@dataclass
class ShopInventory(BaseNode[CustomerTransactionState, CustomerDependency]):
    async def run(self, ctx: GraphRunContext[CustomerTransactionState, CustomerDependency]) -> MainMenu | BrowseInventory | FinalizeShopping:
        pass


@dataclass
class ReturnPriorPurchase(BaseNode[CustomerTransactionState, CustomerDependency]):
    returns_dao: ReturnsDao = None
    purchases_dao: PurchasesDao = None

    async def run(self, ctx: GraphRunContext[CustomerTransactionState, CustomerDependency]) -> MainMenu | FinalizeReturns:
        self.returns_dao = ctx.deps.returns_dao
        self.purchases_dao = ctx.deps.purchases_dao

        prompt_string = """
        Welcome to Customer Returns:
        Enter 1 to Start the Return Process
        Enter 7 to Return to the Main Menu
        """
        menu_options: list[str] = ["1", "7"]
        selected_option: int = IntPrompt.ask(prompt=prompt_string, choices=menu_options, show_choices=False)

        if selected_option == 7:
            return MainMenu()
        else:
            return await self.handle_returns(state=ctx.state)

    async def init_returns(self, state: CustomerTransactionState):

        if not state.active_return_cart:
            cart = self.returns_dao.generate_new_cart(receipt_id=state.receipt_id, customer_id=state.customer_id)
            state.active_return_cart = True
            state.return_cart_id = cart.cart_id

    async def keep_processing_returns(self, state: CustomerTransactionState) -> int:

        print("Thank you for entering your receipt id")
        valid_options = ["1", "2", "3", "4", "5"]
        prompt_message = """
        What would you like to do next: 
        1: Review items from the previous purchase
        2: Review current items you are about to return
        3: Add an item to the return cart. This will add all the units for that SKU
        4: Remove an item from the return cart. This will remove all the units for that SKU
        5: Finalize your returns
        """

        await self.init_returns(state)

        selected_option = IntPrompt.ask(prompt_message, choices=valid_options, show_choices=False)
        current_receipt_id = state.receipt_id
        current_customer_id = state.customer_id
        return_cart_id = state.return_cart_id

        if selected_option == 1:
            previous_purchase = self.purchases_dao.get_existing_purchase(receipt_id=current_receipt_id, customer_id=state.customer_id)
            # TODO: display this using Rich Tables
            print("Here is your previous purchase", previous_purchase)
            return selected_option
        elif selected_option == 2:
            # TODO: display this using Rich Tables
            current_return_cart = self.returns_dao.get_cart(cart_identifier=state.return_cart_id)
            print("Here are the contents of your return cart", current_return_cart)
            return selected_option
        elif selected_option == 3:
            valid_skus = self.purchases_dao.get_existing_purchase_skus(receipt_id=current_receipt_id, customer_id=current_customer_id)
            current_prompt = f"Please enter the SKU you would like to add to the return cart {valid_skus}"
            selected_sku: SkuId = Prompt.ask(current_prompt, choices=valid_skus)
            units_returned = self.purchases_dao.get_existing_purchase_sku_quentity(receipt_id=current_receipt_id, customer_id=current_customer_id, sku_id=selected_sku)
            update_confirmation = self.returns_dao.add_item(cart_identifier=return_cart_id, sku_id=selected_sku, quantity=units_returned)
            print(f"Return cart updated, {update_confirmation}")
            return selected_option
        elif selected_option == 4:
            valid_return_skus = self.returns_dao.get_active_return_skus(cart_id=return_cart_id)
            if len(valid_return_skus) == 0:
                print("There are no items in your return cart, yet. Review your previous purchase and select some items to return")
            else:
                current_prompt = f"Please enter the SKU you would like to remove from the return cart {valid_return_skus}"
                selected_sku: SkuId = Prompt.ask(current_prompt, choices=valid_return_skus, show_choices=False)
                removal_confirmation = self.returns_dao.remove_item(cart_identifier=return_cart_id, sku_id=selected_sku)
                print(f"Return cart updated, {removal_confirmation}")
            return selected_option
        else: # option 5 was selected
            return selected_option


    async def handle_returns(self, state: CustomerTransactionState) -> FinalizeReturns:
        has_valid_receipt_id: bool = False
        customer_id = state.customer_id

        while not has_valid_receipt_id:
            receipt_id = Prompt.ask("Please enter a valid receipt id")
            receipt_lookup = self.purchases_dao.get_existing_purchase(receipt_id=receipt_id, customer_id=customer_id)
            if receipt_lookup is None:
                print(f"Receipt id {receipt_id} was NOT FOUND!")
                continue

            if receipt_lookup.customer_id != customer_id:
                print(f"Customer ID on Receipt Id {receipt_id} does not match your customer ID")
                continue

            else:
                has_valid_receipt_id = True
                state.receipt_id = receipt_id


        continue_returns = await self.keep_processing_returns(state)
        while continue_returns != 5:
            continue_returns = await self.keep_processing_returns(state)

        return FinalizeReturns()





@dataclass
class FinishNode(BaseNode[CustomerTransactionState, None, str]):
    async def run(self, ctx: GraphRunContext[CustomerTransactionState]) -> End[str]:
        print("Thank you for using the Customer Experience at Contoso Groceries where shopping is always a pleasure. Have a nice day")
        return End(ctx.state.customer_id)


@dataclass
class StartNode(BaseNode[CustomerTransactionState]):
    async def run(self, ctx: GraphRunContext[CustomerTransactionState]) -> MainMenu:
        print("Welcome to the Customer Experience at Contoso Groceries where shopping is always a pleasure.")
        print("An agent will be with you shortly. Before we get started, let's have your customer identifier so that we can look up your account information to better assist you.")
        valid_customer_ids = StaticDataset.get_customer_identifiers()
        customer_id: str = Prompt.ask(prompt="Please enter a valid customer id", choices=valid_customer_ids, show_choices=False)

        # Set the customer id property on the shared state
        ctx.state.customer_id = customer_id
        return MainMenu()


@dataclass
class MainMenu(BaseNode[CustomerTransactionState]):
    async def run(self, ctx: GraphRunContext[CustomerTransactionState]) -> BrowseInventory | ShopInventory | ReturnPriorPurchase | FinishNode:
        prompt_string = """
        Welcome to the Main Menu:
        Enter 2 to Browse Inventory
        Enter 3 to Start or Continue Shopping
        Enter 4 to Start or Continue your Returns
        Enter 5 to Exit the Customer Experience
        """
        menu_options: list[str] = ["2", "3", "4", "5"]
        selected_option: int = IntPrompt.ask(prompt=prompt_string, choices=menu_options, show_choices=False)

        if selected_option == 2:
            return BrowseInventory()
        elif selected_option == 3:
            return ShopInventory()
        elif selected_option == 4:
            return ReturnPriorPurchase()
        else:
            return FinishNode()
