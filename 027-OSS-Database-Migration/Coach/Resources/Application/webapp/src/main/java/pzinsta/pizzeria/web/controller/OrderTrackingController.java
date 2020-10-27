package pzinsta.pizzeria.web.controller;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import pzinsta.pizzeria.service.OrderService;
import pzinsta.pizzeria.service.exception.OrderNotFoundException;

@Controller
@RequestMapping("/order/track")
public class OrderTrackingController {

    private OrderService orderService;

    @Autowired
    public OrderTrackingController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping
    public String showOrderTrackerSearchForm() {
        return "orderTrackerSearchForm";
    }

    @PostMapping
    public String processOrderTrackerSearch(@RequestParam("trackingNumber") String trackingNumber, Model model) {
        model.addAttribute("trackingNumber", StringUtils.trim(trackingNumber));
        return "redirect:/order/track/{trackingNumber}";
    }

    @GetMapping("/{trackingNumber}")
    public String showOrderTracker(@PathVariable("trackingNumber") String trackingNumber, Model model) {
        model.addAttribute("order", orderService.getOrderByTrackingNumber(trackingNumber));
        return "showOrderTracker";
    }

    @ExceptionHandler(OrderNotFoundException.class)
    public String handleOrderNotFoundException(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("trackingNumberNotFound", Boolean.TRUE);
        return "redirect:/order/track";
    }
}
