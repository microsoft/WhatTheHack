package pzinsta.pizzeria.web.validator;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import pzinsta.pizzeria.model.user.Customer;

@Component
public class CustomerValidator {

    public void validateEnterGuestInformation(Customer customer, Errors errors) {
        if (StringUtils.isEmpty(customer.getFirstName())) {
            errors.rejectValue("firstName", "firstName.blank");
        }
    }
}
