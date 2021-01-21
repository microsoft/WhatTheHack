package pzinsta.pizzeria.service;

import pzinsta.pizzeria.model.order.Order;
import pzinsta.pizzeria.model.pizza.BakeStyle;
import pzinsta.pizzeria.model.pizza.Crust;
import pzinsta.pizzeria.model.pizza.CutStyle;
import pzinsta.pizzeria.model.pizza.Ingredient;
import pzinsta.pizzeria.model.pizza.IngredientType;
import pzinsta.pizzeria.model.pizza.PizzaSize;
import pzinsta.pizzeria.service.dto.PizzaOrderDTO;
import pzinsta.pizzeria.service.dto.ReviewDTO;

import java.util.Collection;
import java.util.Optional;

public interface OrderService {

    Collection<Crust> getCrusts();

    Collection<PizzaSize> getPizzaSizes();

    Collection<BakeStyle> getBakeStyles();

    Collection<CutStyle> getCutStyles();

    Collection<Ingredient> getIngredients();

    Collection<Integer> getQuantities();

    void addOrderItemToCart(PizzaOrderDTO pizzaOrderDTO);

    void removeOrderItem(int orderItemIndex);

    void emptyCart();

    void replaceOrderItem(int orderItemIndex, PizzaOrderDTO pizzaOrderDTO);

    PizzaOrderDTO getPizzaOrderDTOByOrderItemId(int orderItemIndex);

    IngredientType getIngredientTypeByIngredientId(Long ingredientId);

    Ingredient getIngredientById(Long ingredientId);

    Order postOrder(Order order);

    Order getOrderByTrackingNumber(String trackingNumber);

    void addReviewToOrderByTrackingNumber(String trackingNumber, ReviewDTO reviewDTO);

    Optional<PizzaOrderDTO> getPizzaOrderDTOByOrderItemId(Long orderItemId);
}
