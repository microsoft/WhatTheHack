package pzinsta.pizzeria.web.validator;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import pzinsta.pizzeria.model.user.Customer;
import pzinsta.pizzeria.service.CustomerService;
import pzinsta.pizzeria.web.form.CustomerRegistrationForm;

import java.util.Optional;

@Component
public class CustomerRegistrationFormValidator implements Validator {

    private CustomerService customerService;

    @Override
    public boolean supports(Class<?> clazz) {
        return CustomerRegistrationForm.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        CustomerRegistrationForm customerRegistrationForm = (CustomerRegistrationForm) target;
        validateUsername(customerRegistrationForm, errors);
        validatePasswords(customerRegistrationForm, errors);
    }

    private void validateUsername(CustomerRegistrationForm customerRegistrationForm, Errors errors) {
        Optional<Customer> customerOptional = customerService.getCustomerByUsername(customerRegistrationForm.getUsername());

        if (customerOptional.isPresent()) {
            errors.rejectValue("username", "username.already.exists");
        }
    }

    private void validatePasswords(CustomerRegistrationForm customerRegistrationForm, Errors errors) {
        if (!StringUtils.equals(customerRegistrationForm.getPassword(), customerRegistrationForm.getPasswordAgain())) {
            errors.rejectValue("passwordAgain", "passwords.not.equal");
        }
    }

    public CustomerService getCustomerService() {
        return customerService;
    }

    @Autowired
    public void setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
    }
}
