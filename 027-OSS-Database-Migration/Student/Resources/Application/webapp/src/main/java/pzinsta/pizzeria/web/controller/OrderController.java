package pzinsta.pizzeria.web.controller;

import com.google.common.base.Joiner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import pzinsta.pizzeria.model.pizza.BakeStyle;
import pzinsta.pizzeria.model.pizza.Crust;
import pzinsta.pizzeria.model.pizza.CutStyle;
import pzinsta.pizzeria.model.pizza.PizzaSize;
import pzinsta.pizzeria.service.OrderService;
import pzinsta.pizzeria.web.form.PizzaBuilderForm;
import pzinsta.pizzeria.web.util.Utils;
import pzinsta.pizzeria.web.validator.PizzaBuilderFormValidator;

import javax.validation.Valid;
import java.util.Collection;

import static org.apache.commons.lang3.StringUtils.EMPTY;
import static pzinsta.pizzeria.web.util.Utils.createPizzaOrderDTO;

@Controller
@RequestMapping("/order/orderItem")
public class OrderController {

    private OrderService orderService;
    private PizzaBuilderFormValidator pizzaBuilderFormValidator;

    @Autowired
    public OrderController(OrderService orderService, PizzaBuilderFormValidator pizzaBuilderFormValidator) {
        this.orderService = orderService;
        this.pizzaBuilderFormValidator = pizzaBuilderFormValidator;
    }

    @InitBinder
    public void initBinder(WebDataBinder webDataBinder) {
        webDataBinder.addValidators(pizzaBuilderFormValidator);
    }

    @ModelAttribute("crusts")
    public Collection<Crust> crusts() {
        return orderService.getCrusts();
    }

    @ModelAttribute("pizzaSizes")
    public Collection<PizzaSize> pizzaSizes() {
        return orderService.getPizzaSizes();
    }

    @ModelAttribute("bakeStyles")
    public Collection<BakeStyle> bakeStyles() {
        return orderService.getBakeStyles();
    }

    @ModelAttribute("cutStyles")
    public Collection<CutStyle> cutStyles() {
        return orderService.getCutStyles();
    }

    @ModelAttribute("quantities")
    public Collection<Integer> quantities() {
        return orderService.getQuantities();
    }

    @GetMapping("/{orderItemId}/remove}")
    public String removeOrderItem(@PathVariable("orderItemId") int orderItemIndex, @RequestParam(value = "redirectTo", defaultValue = "/") String redirectTo, RedirectAttributes redirectAttributes) {
        orderService.removeOrderItem(orderItemIndex);
        return Joiner.on(EMPTY).join("redirect:", redirectTo);
    }

    @GetMapping("/clear")
    public String clear(@RequestParam(value = "redirectTo", defaultValue = "/") String redirectTo, RedirectAttributes redirectAttributes) {
        orderService.emptyCart();
        return Joiner.on(EMPTY).join("redirect:", redirectTo);
    }

    @GetMapping("/{orderItemId}/edit")
    public String showEditOrderItemForm(@PathVariable("orderItemId") int orderItemIndex, Model model) {

        model.addAttribute("pizzaBuilderForm", Utils.createPizzaBuilderForm(orderService.getPizzaOrderDTOByOrderItemId(orderItemIndex), orderService.getIngredients()));

        return "editOrderItem";
    }

    @PostMapping("/{orderItemId}/edit")
    public String editOrderItem(@PathVariable("orderItemId") int orderItemIndex, @ModelAttribute @Valid PizzaBuilderForm pizzaBuilderForm, BindingResult bindingResult, @RequestParam(value = "redirectTo", defaultValue = "/") String redirectTo, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
           return "editOrderItem";
        }

        orderService.replaceOrderItem(orderItemIndex, createPizzaOrderDTO(pizzaBuilderForm));
        return Joiner.on(EMPTY).join("redirect:", redirectTo);
    }


}
