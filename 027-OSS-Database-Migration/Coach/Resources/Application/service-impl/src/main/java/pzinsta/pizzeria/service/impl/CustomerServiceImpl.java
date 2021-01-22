package pzinsta.pizzeria.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pzinsta.pizzeria.dao.AccountDAO;
import pzinsta.pizzeria.dao.CustomerDAO;
import pzinsta.pizzeria.model.user.Account;
import pzinsta.pizzeria.model.user.Customer;
import pzinsta.pizzeria.service.CustomerService;

import java.util.Optional;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    private CustomerDAO customerDAO;
    private AccountDAO accountDAO;

    @Override
    @Transactional(readOnly = true)
    public Optional<Customer> getCustomerByUsername(String username) {
        Optional<Account> accountOptional = accountDAO.findByUsername(username);
        return accountOptional.flatMap(account -> customerDAO.findById(account.getUser().getId()));
    }

    @Override
    public Customer createNewCustomer() {
        return new Customer();
    }

    @Override
    @Transactional
    public void updateCustomer(Customer customer) {
        customerDAO.saveOrUpdate(customer);
    }

    public CustomerDAO getCustomerDAO() {
        return customerDAO;
    }

    @Autowired
    public void setCustomerDAO(CustomerDAO customerDAO) {
        this.customerDAO = customerDAO;
    }

    public AccountDAO getAccountDAO() {
        return accountDAO;
    }

    @Autowired
    public void setAccountDAO(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }

}
