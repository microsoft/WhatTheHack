package pzinsta.pizzeria.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import pzinsta.pizzeria.service.CustomerRegistrationService;
import pzinsta.pizzeria.service.dto.CustomerRegistrationDTO;
import pzinsta.pizzeria.web.form.CustomerRegistrationForm;
import pzinsta.pizzeria.web.service.GoogleReCaptchaService;
import pzinsta.pizzeria.web.validator.CustomerRegistrationFormValidator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

@Controller
@RequestMapping("/account/register")
public class RegistrationController {

    private CustomerRegistrationService customerRegistrationService;
    private CustomerRegistrationFormValidator customerRegistrationFormValidator;
    private GoogleReCaptchaService googleReCaptchaService;
    private PasswordEncoder passwordEncoder;

    @Value("${recaptcha.public.key}")
    private String recaptchaPublicKey;

    @InitBinder
    public void initBinder(WebDataBinder webDataBinder) {
        webDataBinder.addValidators(customerRegistrationFormValidator);
    }

    @ModelAttribute("recaptchaPublicKey")
    public String recaptchaPublicKey() {
        return recaptchaPublicKey;
    }

    @GetMapping
    public String showRegistrationForm(Model model) {
        model.addAttribute("customerRegistrationForm", new CustomerRegistrationForm());
        return "register";
    }

    @PostMapping
    public String processRegistrationForm(@Valid @ModelAttribute("customerRegistrationForm") CustomerRegistrationForm customerRegistrationForm,
                                          BindingResult bindingResult, HttpServletRequest httpServletRequest,
                                          @RequestParam(name = "returnUrl", defaultValue = "/") String returnUrl,
                                          @RequestParam("g-recaptcha-response") String recaptchaResponse) throws ServletException {
        if (bindingResult.hasErrors()) {
            return "register";
        }

        if (!googleReCaptchaService.isValid(recaptchaResponse)) {
            return "register";
        }

        customerRegistrationService.processRegistration(convertRegistrationFormToRegistrationDTO(customerRegistrationForm));

        httpServletRequest.login(customerRegistrationForm.getUsername(), customerRegistrationForm.getPassword());

        return "redirect:" + returnUrl;
    }

    private CustomerRegistrationDTO convertRegistrationFormToRegistrationDTO(CustomerRegistrationForm customerRegistrationForm) {
        CustomerRegistrationDTO customerRegistrationDTO = new CustomerRegistrationDTO();
        customerRegistrationDTO.setUsername(customerRegistrationForm.getUsername());
        customerRegistrationDTO.setPassword(passwordEncoder.encode(customerRegistrationForm.getPassword()));
        customerRegistrationDTO.setFirstName(customerRegistrationForm.getFirstName());
        customerRegistrationDTO.setLastName(customerRegistrationForm.getLastName());
        customerRegistrationDTO.setEmail(customerRegistrationForm.getEmail());
        customerRegistrationDTO.setPhoneNumber(customerRegistrationForm.getPhoneNumber());
        return customerRegistrationDTO;
    }

    public GoogleReCaptchaService getGoogleReCaptchaService() {
        return googleReCaptchaService;
    }

    @Autowired
    public void setGoogleReCaptchaService(GoogleReCaptchaService googleReCaptchaService) {
        this.googleReCaptchaService = googleReCaptchaService;
    }

    public PasswordEncoder getPasswordEncoder() {
        return passwordEncoder;
    }

    @Autowired
    public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    @Autowired
    public void setCustomerRegistrationService(CustomerRegistrationService customerRegistrationService) {
        this.customerRegistrationService = customerRegistrationService;
    }

    @Autowired
    public void setCustomerRegistrationFormValidator(CustomerRegistrationFormValidator customerRegistrationFormValidator) {
        this.customerRegistrationFormValidator = customerRegistrationFormValidator;
    }
}
