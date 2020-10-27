package pzinsta.pizzeria.web.controller;

import com.google.common.base.Joiner;
import com.google.common.collect.Range;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import pzinsta.pizzeria.model.user.Customer;
import pzinsta.pizzeria.model.user.DeliveryAddress;
import pzinsta.pizzeria.service.CustomerService;
import pzinsta.pizzeria.service.exception.CustomerNotFoundException;
import pzinsta.pizzeria.web.form.DeliveryAddressForm;
import pzinsta.pizzeria.web.validator.DeliveryAddressFormValidator;

import javax.validation.Valid;
import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/customer/deliveryAddress")
public class DeliveryAddressController {

    private CustomerService customerService;
    private DeliveryAddressFormValidator deliveryAddressFormValidator;

    @Value("${delivery.cities}")
    private List<String> cities;

    @Autowired
    public DeliveryAddressController(CustomerService customerService, DeliveryAddressFormValidator deliveryAddressFormValidator) {
        this.customerService = customerService;
        this.deliveryAddressFormValidator = deliveryAddressFormValidator;
    }

    @ModelAttribute("cities")
    public List<String> cities() {
        return cities;
    }

    @InitBinder
    public void initBinder(WebDataBinder webDataBinder) {
        webDataBinder.addValidators(deliveryAddressFormValidator);
    }

    @GetMapping("/{deliveryAddressIndex}")
    public String showEditDeliveryAddressForm(@PathVariable("deliveryAddressIndex") int deliveryAddressIndex, Model model, Principal principal) {
        Customer customer = getCustomerFromPrincipal(principal);
        DeliveryAddress deliveryAddress = customer.getDeliveryAddresses().get(deliveryAddressIndex);
        model.addAttribute("deliveryAddressForm", transformDeliveryAddressToDeliveryAddressForm(deliveryAddress));
        return "editDeliveryAddress";
    }

    @PostMapping("/{deliveryAddressIndex}")
    public String updateDeliveryAddress(@ModelAttribute @Valid DeliveryAddressForm deliveryAddressForm, BindingResult bindingResult, @PathVariable("deliveryAddressIndex") int deliveryAddressIndex, @RequestParam(name = "returnUrl", defaultValue = "/customer") String returnUrl, Principal principal, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "editDeliveryAddress";
        }
        Customer customer = getCustomerFromPrincipal(principal);
        DeliveryAddress deliveryAddressToUpdate = customer.getDeliveryAddresses().get(deliveryAddressIndex);
        updateDeliveryAddressWithValuesFromDeliveryAddressForm(deliveryAddressForm, deliveryAddressToUpdate);
        customerService.updateCustomer(customer);
        return Joiner.on(StringUtils.EMPTY).join("redirect:", returnUrl);
    }

    @GetMapping("/{deliveryAddressIndex}/remove")
    public String removeDeliveryAddress(@PathVariable("deliveryAddressIndex") int deliveryAddressIndex, @RequestParam(name = "returnUrl", defaultValue = "/customer") String returnUrl, Principal principal, RedirectAttributes redirectAttributes) {
        Customer customer = getCustomerFromPrincipal(principal);
        Range<Integer> indexRange = Range.closedOpen(0, customer.getDeliveryAddresses().size());
        if (indexRange.contains(deliveryAddressIndex)) {
            customer.getDeliveryAddresses().remove(deliveryAddressIndex);
            customerService.updateCustomer(customer);
        }
        return Joiner.on(StringUtils.EMPTY).join("redirect:", returnUrl);
    }

    @GetMapping("/add")
    public String showAddDeliveryAddressForm(Model model) {

        model.addAttribute("deliveryAddressForm", new DeliveryAddressForm());

        return "addDeliveryAddress";
    }

    @PostMapping("/add")
    public String addDeliveryAddress(@ModelAttribute @Valid DeliveryAddressForm deliveryAddressForm, BindingResult bindingResult, Principal principal, @RequestParam(name = "returnUrl", defaultValue = "/customer") String returnUrl, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "addDeliveryAddress";
        }

        Customer customer = getCustomerFromPrincipal(principal);
        customer.getDeliveryAddresses().add(transformDeliveryAddressFormToDeliveryAddress(deliveryAddressForm));
        customerService.updateCustomer(customer);
        return Joiner.on(StringUtils.EMPTY).join("redirect:", returnUrl);
    }

    private Customer getCustomerFromPrincipal(Principal principal) {
        return customerService.getCustomerByUsername(principal.getName()).orElseThrow(CustomerNotFoundException::new);
    }

    private DeliveryAddressForm transformDeliveryAddressToDeliveryAddressForm(DeliveryAddress deliveryAddress) {
        DeliveryAddressForm deliveryAddressForm = new DeliveryAddressForm();
        deliveryAddressForm.setCity(deliveryAddress.getCity());
        deliveryAddressForm.setStreet(deliveryAddress.getStreet());
        deliveryAddressForm.setHouseNumber(deliveryAddress.getHouseNumber());
        deliveryAddressForm.setApartmentNumber(deliveryAddress.getApartmentNumber());
        return deliveryAddressForm;
    }

    private void updateDeliveryAddressWithValuesFromDeliveryAddressForm(DeliveryAddressForm deliveryAddressForm, DeliveryAddress deliveryAddressToUpdate) {
        deliveryAddressToUpdate.setCity(deliveryAddressForm.getCity());
        deliveryAddressToUpdate.setStreet(deliveryAddressForm.getStreet());
        deliveryAddressToUpdate.setHouseNumber(deliveryAddressForm.getHouseNumber());
        deliveryAddressToUpdate.setApartmentNumber(deliveryAddressForm.getApartmentNumber());
    }

    private DeliveryAddress transformDeliveryAddressFormToDeliveryAddress(DeliveryAddressForm deliveryAddressForm) {
        DeliveryAddress deliveryAddress = new DeliveryAddress();
        deliveryAddress.setCity(deliveryAddressForm.getCity());
        deliveryAddress.setStreet(deliveryAddressForm.getStreet());
        deliveryAddress.setHouseNumber(deliveryAddressForm.getHouseNumber());
        deliveryAddress.setApartmentNumber(deliveryAddressForm.getApartmentNumber());
        return deliveryAddress;
    }

    public List<String> getCities() {
        return cities;
    }

    public void setCities(List<String> cities) {
        this.cities = cities;
    }

    public DeliveryAddressFormValidator getDeliveryAddressFormValidator() {
        return deliveryAddressFormValidator;
    }

    public void setDeliveryAddressFormValidator(DeliveryAddressFormValidator deliveryAddressFormValidator) {
        this.deliveryAddressFormValidator = deliveryAddressFormValidator;
    }
}
