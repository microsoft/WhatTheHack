package pzinsta.pizzeria.service.impl;

import com.google.common.collect.ImmutableSet;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import pzinsta.pizzeria.dao.AccountDAO;
import pzinsta.pizzeria.model.user.Account;
import pzinsta.pizzeria.model.user.Customer;
import pzinsta.pizzeria.model.user.Role;
import pzinsta.pizzeria.service.dto.CustomerRegistrationDTO;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;

public class CustomerRegistrationServiceImplTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private AccountDAO accountDAO;

    @InjectMocks
    private CustomerRegistrationServiceImpl customerRegistrationService;
    public static final String USERNAME = "john.doe";
    public static final String PASSWORD = "secret";
    public static final String PHONE_NUMBER = "123456789";
    public static final String EMAIL = "john.doe@example.com";
    public static final String FIRST_NAME = "John";
    public static final String LAST_NAME = "Doe";

    @Test
    public void shouldProcessRegistration() throws Exception {
        // given
        CustomerRegistrationDTO customerRegistrationDTO = createCustomerRegistrationDTO();

        // when
        customerRegistrationService.processRegistration(customerRegistrationDTO);

        // then
        ArgumentCaptor<Account> accountArgumentCaptor = ArgumentCaptor.forClass(Account.class);
        verify(accountDAO).saveOrUpdate(accountArgumentCaptor.capture());

        Account result = accountArgumentCaptor.getValue();
        Account expected = createExpectedAccount();

        assertThat(result).isEqualToComparingFieldByFieldRecursively(expected);
    }

    private CustomerRegistrationDTO createCustomerRegistrationDTO() {
        CustomerRegistrationDTO customerRegistrationDTO = new CustomerRegistrationDTO();
        customerRegistrationDTO.setUsername(USERNAME);
        customerRegistrationDTO.setPassword(PASSWORD);
        customerRegistrationDTO.setPhoneNumber(PHONE_NUMBER);
        customerRegistrationDTO.setEmail(EMAIL);
        customerRegistrationDTO.setFirstName(FIRST_NAME);
        customerRegistrationDTO.setLastName(LAST_NAME);
        return customerRegistrationDTO;
    }

    private Account createExpectedAccount() {
        Account expected = new Account();
        expected.setRoles(ImmutableSet.of(Role.REGISTERED_CUSTOMER));
        expected.setCredentialsExpired(false);
        expected.setAccountLocked(false);
        expected.setAccountExpired(false);
        expected.setEnabled(true);
        expected.setUsername(USERNAME);
        expected.setPassword(PASSWORD);
        Customer customer = new Customer();
        customer.setAccount(expected);
        customer.setFirstName(FIRST_NAME);
        customer.setLastName(LAST_NAME);
        customer.setEmail(EMAIL);
        customer.setPhoneNumber(PHONE_NUMBER);
        expected.setUser(customer);
        return expected;
    }
}