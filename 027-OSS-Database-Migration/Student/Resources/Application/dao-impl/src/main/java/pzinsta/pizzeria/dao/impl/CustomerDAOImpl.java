package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.CustomerDAO;
import pzinsta.pizzeria.model.user.Customer;

@Repository
public class CustomerDAOImpl extends GenericDAOImpl<Customer, Long> implements CustomerDAO {

    public CustomerDAOImpl() {
        super(Customer.class);
    }
}
