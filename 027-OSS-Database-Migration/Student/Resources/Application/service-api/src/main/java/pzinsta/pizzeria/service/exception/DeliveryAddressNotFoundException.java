package pzinsta.pizzeria.service.exception;

public class DeliveryAddressNotFoundException extends RuntimeException {
    public DeliveryAddressNotFoundException() {
    }

    public DeliveryAddressNotFoundException(String message) {
        super(message);
    }

    public DeliveryAddressNotFoundException(Long deliveryAddressIndex) {
        this("Delivery address with ID " + deliveryAddressIndex + "was not found.");
    }
}
