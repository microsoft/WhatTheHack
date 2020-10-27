package pzinsta.pizzeria.web.validator;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import pzinsta.pizzeria.web.form.DeliveryAddressForm;

import java.util.List;

@Component
public class DeliveryAddressFormValidator implements Validator {

    @Value("${delivery.cities}")
    private List<String> cities;

    @Override
    public boolean supports(Class<?> clazz) {
        return DeliveryAddressForm.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DeliveryAddressForm deliveryAddressForm = (DeliveryAddressForm) target;

        if (!cities.contains(deliveryAddressForm.getCity())) {
            errors.rejectValue("city", "city.invalid");
        }
    }
}
