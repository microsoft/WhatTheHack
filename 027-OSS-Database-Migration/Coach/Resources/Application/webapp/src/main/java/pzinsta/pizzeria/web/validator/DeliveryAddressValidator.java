package pzinsta.pizzeria.web.validator;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import pzinsta.pizzeria.model.user.DeliveryAddress;

import java.util.List;

@Component
public class DeliveryAddressValidator {

    @Value("${delivery.cities}")
    private List<String> cities;

    public void validateEnterGuestDeliveryAddress(DeliveryAddress deliveryAddress, Errors errors) {
        if (!cities.contains(deliveryAddress.getCity())) {
            errors.rejectValue("city", "city.invalid");
        }

    }
}
