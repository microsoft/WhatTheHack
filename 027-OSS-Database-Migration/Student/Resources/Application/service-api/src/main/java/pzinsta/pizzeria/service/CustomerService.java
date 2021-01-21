package pzinsta.pizzeria.service;

import pzinsta.pizzeria.model.user.Customer;

import java.util.Optional;

public interface CustomerService {
    Optional<Customer> getCustomerByUsername(String username);

    Customer createNewCustomer();

    void updateCustomer(Customer customer);

}
