package pzinsta.pizzeria.web.controller;

import com.google.common.base.Joiner;
import org.apache.commons.lang3.StringUtils;
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
import pzinsta.pizzeria.service.dto.PizzaOrderDTO;
import pzinsta.pizzeria.web.form.PizzaBuilderForm;
import pzinsta.pizzeria.web.util.Utils;
import pzinsta.pizzeria.web.validator.PizzaBuilderFormValidator;

import javax.validation.Valid;
import java.util.Collection;
import java.util.Optional;

import static pzinsta.pizzeria.web.util.Utils.createPizzaOrderDTO;
import static pzinsta.pizzeria.web.util.Utils.generateIngredientGroups;

@Controller
@RequestMapping("/builder")
public class PizzaBuilderController {

    private OrderService orderService;
    private PizzaBuilderFormValidator pizzaBuilderFormValidator;

    @Autowired
    public PizzaBuilderController(OrderService orderService, PizzaBuilderFormValidator pizzaBuilderFormValidator) {
        this.orderService = orderService;
        this.pizzaBuilderFormValidator = pizzaBuilderFormValidator;
    }

    @InitBinder("pizzaBuilderForm")
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

    @GetMapping
    public String showPizzaBuilderForm(Model model) {
        PizzaBuilderForm pizzaBuilderForm = new PizzaBuilderForm();
        pizzaBuilderForm.setIngredientGroups(generateIngredientGroups(orderService.getIngredients()));
        model.addAttribute("pizzaBuilderForm", pizzaBuilderForm);
        return "pizzaBuilder";
    }

    @PostMapping("/**")
    public String processPizzaBuilderForm(@Valid @ModelAttribute PizzaBuilderForm pizzaBuilderForm, BindingResult bindingResult, @RequestParam(value = "redirectTo", defaultValue = "/") String redirectTo, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "pizzaBuilder";
        }

        orderService.addOrderItemToCart(createPizzaOrderDTO(pizzaBuilderForm));

        return Joiner.on(StringUtils.EMPTY).join("redirect:", redirectTo);
    }

    @GetMapping("/template/{orderItemId}")
    public String showPizzaBuilderFormForOrderItem(Model model, @PathVariable("orderItemId") Long orderItemId) {
        Optional<PizzaOrderDTO> pizzaOrderDTOOptional = orderService.getPizzaOrderDTOByOrderItemId(orderItemId);

        PizzaBuilderForm pizzaBuilderForm = pizzaOrderDTOOptional.map(pizzaOrderDTO ->
                Utils.createPizzaBuilderForm(pizzaOrderDTO, orderService.getIngredients())
        ).orElse(new PizzaBuilderForm());

        model.addAttribute("pizzaBuilderForm", pizzaBuilderForm);

        return "pizzaBuilder";
    }

    public OrderService getOrderService() {
        return orderService;
    }

    public void setOrderService(OrderService orderService) {
        this.orderService = orderService;
    }

    public PizzaBuilderFormValidator getPizzaBuilderFormValidator() {
        return pizzaBuilderFormValidator;
    }

    public void setPizzaBuilderFormValidator(PizzaBuilderFormValidator pizzaBuilderFormValidator) {
        this.pizzaBuilderFormValidator = pizzaBuilderFormValidator;
    }
}
