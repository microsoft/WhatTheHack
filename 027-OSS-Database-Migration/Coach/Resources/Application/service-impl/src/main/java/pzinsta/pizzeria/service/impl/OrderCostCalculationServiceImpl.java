package pzinsta.pizzeria.service.impl;

import org.springframework.stereotype.Service;
import pzinsta.pizzeria.model.order.Order;
import pzinsta.pizzeria.model.order.OrderItem;
import pzinsta.pizzeria.model.pizza.Pizza;
import pzinsta.pizzeria.model.pizza.PizzaSide;
import pzinsta.pizzeria.service.OrderCostCalculationService;

import javax.money.Monetary;
import javax.money.MonetaryAmount;

@Service("orderCostCalculationService")
public class OrderCostCalculationServiceImpl implements OrderCostCalculationService {

    private static final MonetaryAmount ZERO = Monetary.getDefaultAmountFactory().setNumber(0).setCurrency("USD").create();

    @Override
    public MonetaryAmount calculateCost(Order order) {
        return order.getOrderItems().stream()
                .map(OrderCostCalculationServiceImpl::calculateOrderItemCost)
                .reduce(ZERO, MonetaryAmount::add);
    }

    private static MonetaryAmount calculateOrderItemCost(OrderItem orderItem) {
        return calculatePizzaCost(orderItem.getPizza()).multiply(orderItem.getQuantity());
    }

    private static MonetaryAmount calculatePizzaCost(Pizza pizza) {
        MonetaryAmount crustCost = pizza.getCrust().getPrice();
        MonetaryAmount pizzaSizeCost = pizza.getSize().getPrice();

        double ingredientCostFactor = pizza.getSize().getIngredientCostFactor();
        MonetaryAmount leftPizzaSideIngredientsCost = calculatePizzaSideIngredientsCost(pizza.getLeftPizzaSide()).multiply(ingredientCostFactor);
        MonetaryAmount rightPizzaSideIngredientsCost = calculatePizzaSideIngredientsCost(pizza.getRightPizzaSide()).multiply(ingredientCostFactor);

        return crustCost.add(pizzaSizeCost).add(leftPizzaSideIngredientsCost).add(rightPizzaSideIngredientsCost);
    }

    private static MonetaryAmount calculatePizzaSideIngredientsCost(PizzaSide pizzaSide) {
        return pizzaSide.getPizzaItems().stream()
                .map(pizzaItem -> pizzaItem.getIngredient().getPrice().multiply(pizzaItem.getQuantity()))
                .reduce(ZERO, MonetaryAmount::add);
    }
}
