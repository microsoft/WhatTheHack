package pzinsta.pizzeria.service.impl;

import com.google.common.collect.ImmutableList;
import org.assertj.core.api.Assertions;
import org.junit.Test;
import pzinsta.pizzeria.model.order.Order;
import pzinsta.pizzeria.model.order.OrderItem;
import pzinsta.pizzeria.model.pizza.Crust;
import pzinsta.pizzeria.model.pizza.Ingredient;
import pzinsta.pizzeria.model.pizza.Pizza;
import pzinsta.pizzeria.model.pizza.PizzaItem;
import pzinsta.pizzeria.model.pizza.PizzaSide;
import pzinsta.pizzeria.model.pizza.PizzaSize;

import javax.money.Monetary;
import javax.money.MonetaryAmount;

public class OrderCostCalculationServiceImplTest {

    @Test
    public void shouldCalculateCost() throws Exception {
        // given
        OrderCostCalculationServiceImpl orderCostCalculationService = new OrderCostCalculationServiceImpl();
        Order order = createOrder();

        // when
        MonetaryAmount result = orderCostCalculationService.calculateCost(order);

        // then
        Assertions.assertThat(result).isEqualTo(fromDouble(99));
    }

    private static Order createOrder() {
        Order order = new Order();

        PizzaSize pizzaSize = new PizzaSize();
        pizzaSize.setPrice(fromDouble(15));
        pizzaSize.setIngredientCostFactor(3);

        Crust crust = new Crust();
        crust.setPrice(fromDouble(3));

        Ingredient tomato = new Ingredient();
        tomato.setPrice(fromDouble(1));

        Ingredient cheese = new Ingredient();
        cheese.setPrice(fromDouble(2));

        Ingredient mushroom = new Ingredient();
        mushroom.setPrice(fromDouble(1));

        PizzaItem tomatoPizzaItem = new PizzaItem();
        tomatoPizzaItem.setIngredient(tomato);
        tomatoPizzaItem.setQuantity(2);

        PizzaItem cheesePizzaItem = new PizzaItem();
        cheesePizzaItem.setIngredient(cheese);
        cheesePizzaItem.setQuantity(1);

        PizzaSide leftPizzaSide = new PizzaSide();
        leftPizzaSide.setPizzaItems(ImmutableList.of(tomatoPizzaItem, cheesePizzaItem));

        PizzaItem mushroomPizzaItem = new PizzaItem();
        mushroomPizzaItem.setIngredient(mushroom);
        mushroomPizzaItem.setQuantity(1);

        PizzaSide rightPizzaSide = new PizzaSide();
        rightPizzaSide.setPizzaItems(ImmutableList.of(mushroomPizzaItem));

        Pizza pizza = new Pizza();
        pizza.setSize(pizzaSize);
        pizza.setCrust(crust);
        pizza.setLeftPizzaSide(leftPizzaSide);
        pizza.setRightPizzaSide(rightPizzaSide);

        OrderItem orderItem = new OrderItem();
        orderItem.setQuantity(3);
        orderItem.setPizza(pizza);
        order.setOrderItems(ImmutableList.of(orderItem));

        return order;
    }

    private static MonetaryAmount fromDouble(double amount) {
        return Monetary.getDefaultAmountFactory().setCurrency("USD").setNumber(amount).create();
    }
}