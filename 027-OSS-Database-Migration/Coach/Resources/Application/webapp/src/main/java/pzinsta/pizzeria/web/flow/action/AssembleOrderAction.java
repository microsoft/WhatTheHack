package pzinsta.pizzeria.web.flow.action;

import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.webflow.action.AbstractAction;
import org.springframework.webflow.execution.Event;
import org.springframework.webflow.execution.RequestContext;
import pzinsta.pizzeria.model.delivery.Delivery;
import pzinsta.pizzeria.model.delivery.DeliveryStatus;
import pzinsta.pizzeria.model.order.Cart;
import pzinsta.pizzeria.model.order.Order;
import pzinsta.pizzeria.model.order.OrderEvent;
import pzinsta.pizzeria.model.order.OrderEventType;
import pzinsta.pizzeria.model.user.Customer;
import pzinsta.pizzeria.model.user.DeliveryAddress;

import java.time.Instant;

@Component
public class AssembleOrderAction extends AbstractAction {

    private Cart cart;

    @Autowired
    public AssembleOrderAction(Cart cart) {
        this.cart = cart;
    }

    @Override
    protected Event doExecute(RequestContext context) throws Exception {
        Customer customer = context.getFlowScope().get("customer", Customer.class);
        DeliveryAddress deliveryAddress = context.getFlowScope().get("deliveryAddress", DeliveryAddress.class);

        Order order = new Order();
        order.setOrderItems(ImmutableList.copyOf(cart.getOrderItems()));
        order.getOrderItems().forEach(orderItem -> orderItem.setOrder(order));
        order.setCustomer(customer);
        customer.getOrders().add(order);

        OrderEvent orderEvent = new OrderEvent();
        orderEvent.setOrderEventType(OrderEventType.CREATED);
        orderEvent.setOccurredOn(Instant.now());
        order.getOrderEvents().add(orderEvent);

        Boolean deliveryRequired = context.getFlowScope().getBoolean("deliveryRequired");

        if (deliveryRequired) {
            Delivery delivery = new Delivery();
            delivery.setDeliveryAddress(deliveryAddress);
            delivery.setOrder(order);
            delivery.setStatus(DeliveryStatus.PENDING);

            order.setDelivery(delivery);
        }

        context.getFlowScope().put("order", order);

        return success();
    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }
}
