package pzinsta.pizzeria.service.impl;

import com.google.common.collect.ImmutableSet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pzinsta.pizzeria.dao.AccountDAO;
import pzinsta.pizzeria.model.user.Account;
import pzinsta.pizzeria.model.user.Customer;
import pzinsta.pizzeria.model.user.Role;
import pzinsta.pizzeria.service.CustomerRegistrationService;
import pzinsta.pizzeria.service.dto.CustomerRegistrationDTO;

@Service
public class CustomerRegistrationServiceImpl implements CustomerRegistrationService {

    private AccountDAO accountDAO;

    @Autowired
    public CustomerRegistrationServiceImpl(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }

    @Override
    @Transactional
    public void processRegistration(CustomerRegistrationDTO customerRegistrationDTO) {
        Customer customer = createCustomerFromCustomerRegistrationDTO(customerRegistrationDTO);
        Account account = createAccountFromCustomerRegistrationDTO(customerRegistrationDTO);

        account.setUser(customer);
        customer.setAccount(account);

        accountDAO.saveOrUpdate(account);
    }

    private Customer createCustomerFromCustomerRegistrationDTO(CustomerRegistrationDTO customerRegistrationDTO) {
        Customer customer = new Customer();
        customer.setFirstName(customerRegistrationDTO.getFirstName());
        customer.setLastName(customerRegistrationDTO.getLastName());
        customer.setEmail(customerRegistrationDTO.getEmail());
        customer.setPhoneNumber(customerRegistrationDTO.getPhoneNumber());
        return customer;
    }

    private Account createAccountFromCustomerRegistrationDTO(CustomerRegistrationDTO customerRegistrationDTO) {
        Account account = new Account();
        account.setUsername(customerRegistrationDTO.getUsername());
        account.setPassword(customerRegistrationDTO.getPassword());
        account.setEnabled(true);
        account.setAccountExpired(false);
        account.setAccountLocked(false);
        account.setCredentialsExpired(false);
        account.setRoles(ImmutableSet.of(Role.REGISTERED_CUSTOMER));
        return account;
    }

    public AccountDAO getAccountDAO() {
        return accountDAO;
    }

    public void setAccountDAO(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }
}
