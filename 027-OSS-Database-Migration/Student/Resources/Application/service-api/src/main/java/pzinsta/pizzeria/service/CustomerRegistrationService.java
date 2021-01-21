package pzinsta.pizzeria.service;

import pzinsta.pizzeria.service.dto.CustomerRegistrationDTO;

public interface CustomerRegistrationService {
    void processRegistration(CustomerRegistrationDTO customerRegistrationDTO);
}
