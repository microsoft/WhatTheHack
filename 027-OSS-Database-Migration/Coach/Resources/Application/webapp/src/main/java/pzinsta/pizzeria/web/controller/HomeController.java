package pzinsta.pizzeria.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import pzinsta.pizzeria.model.order.OrderItemTemplate;
import pzinsta.pizzeria.service.OrderItemTemplateService;

import java.util.Collection;

@Controller
@RequestMapping("/")
public class HomeController {

    private OrderItemTemplateService orderItemTemplateService;

    @Autowired
    public HomeController(OrderItemTemplateService orderItemTemplateService) {
        this.orderItemTemplateService = orderItemTemplateService;
    }

    @ModelAttribute("orderItemTemplates")
    public Collection<OrderItemTemplate> orderItemTemplates() {
        return  orderItemTemplateService.getOrderItemTemplates();
    }

    @GetMapping
    public String home(Model model) {
        return "home";
    }

    public OrderItemTemplateService getOrderItemTemplateService() {
        return orderItemTemplateService;
    }

    public void setOrderItemTemplateService(OrderItemTemplateService orderItemTemplateService) {
        this.orderItemTemplateService = orderItemTemplateService;
    }
}
