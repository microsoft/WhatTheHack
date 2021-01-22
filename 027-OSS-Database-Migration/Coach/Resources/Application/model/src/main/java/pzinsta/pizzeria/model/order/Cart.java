package pzinsta.pizzeria.model.order;

import java.util.List;
import java.util.Optional;

public class Cart {

    private Order order = new Order();

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public List<OrderItem> getOrderItems() {
        return order.getOrderItems();
    }

    public void addOrderItem(OrderItem orderItem) {
        order.addOrderItem(orderItem);
    }

    public void removeOrderItemById(int orderItemId) {
       order.removeOrderItemById(orderItemId);
    }

    public void reset() {
        order = new Order();
    }

    public Optional<OrderItem> getOrderItemById(int orderItemId) {
        return order.getOrderItemByIndex(orderItemId);
    }
}
