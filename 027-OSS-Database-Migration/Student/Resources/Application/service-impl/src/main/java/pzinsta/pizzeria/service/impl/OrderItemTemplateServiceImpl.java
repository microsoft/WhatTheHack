package pzinsta.pizzeria.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pzinsta.pizzeria.dao.OrderItemTemplateDAO;
import pzinsta.pizzeria.model.order.OrderItemTemplate;
import pzinsta.pizzeria.service.OrderItemTemplateService;

import java.util.Collection;

@Service
public class OrderItemTemplateServiceImpl implements OrderItemTemplateService {

    private OrderItemTemplateDAO orderItemTemplateDAO;

    @Autowired
    public OrderItemTemplateServiceImpl(OrderItemTemplateDAO orderItemTemplateDAO) {
        this.orderItemTemplateDAO = orderItemTemplateDAO;
    }

    @Override
    public Collection<OrderItemTemplate> getOrderItemTemplates() {
        return orderItemTemplateDAO.findAll();
    }
}
