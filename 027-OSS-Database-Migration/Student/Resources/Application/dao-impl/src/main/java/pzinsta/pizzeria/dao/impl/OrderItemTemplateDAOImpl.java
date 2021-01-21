package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.OrderItemTemplateDAO;
import pzinsta.pizzeria.model.order.OrderItemTemplate;

@Repository
public class OrderItemTemplateDAOImpl extends GenericDAOImpl<OrderItemTemplate, Long> implements OrderItemTemplateDAO {

    public OrderItemTemplateDAOImpl() {
        super(OrderItemTemplate.class);
    }
}
