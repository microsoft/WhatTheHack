package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.OrderItemDAO;
import pzinsta.pizzeria.model.order.OrderItem;

@Repository
public class OrderItemDAOImpl extends GenericDAOImpl<OrderItem, Long> implements OrderItemDAO {

    public OrderItemDAOImpl() {
        super(OrderItem.class);
    }
}
