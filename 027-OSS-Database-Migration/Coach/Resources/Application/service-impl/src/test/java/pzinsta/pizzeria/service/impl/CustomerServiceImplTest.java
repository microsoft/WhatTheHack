package pzinsta.pizzeria.service.impl;

import org.junit.Rule;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.ArgumentMatchers;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import pzinsta.pizzeria.dao.AccountDAO;
import pzinsta.pizzeria.dao.CustomerDAO;
import pzinsta.pizzeria.model.user.Account;
import pzinsta.pizzeria.model.user.Customer;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;

public class CustomerServiceImplTest {

    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private AccountDAO accountDAO;

    @Mock
    private CustomerDAO customerDAO;

    @InjectMocks
    private CustomerServiceImpl userService;

    @Test
    public void shouldGetCustomerByUsername() throws Exception {
        // given
        String username = "john.doe";
        Long customerId = 42L;

        Customer customer = new Customer();
        customer.setId(customerId);

        Account account = new Account();
        account.setUser(customer);

        Mockito.when(accountDAO.findByUsername(username)).thenReturn(Optional.of(account));
        Mockito.when(customerDAO.findById(customerId)).thenReturn(Optional.of(customer));

        // when
        Optional<Customer> result = userService.getCustomerByUsername(username);

        // then
        assertThat(result).contains(customer);
    }

    @Test
    public void shouldReturnEmptyOptionalWhenAccountIsNotFound() throws Exception {
        // given
        Mockito.when(accountDAO.findByUsername(ArgumentMatchers.anyString())).thenReturn(Optional.empty());

        // when
        Optional<Customer> result = userService.getCustomerByUsername("john");

        // then
        assertThat(result).isEmpty();
    }

    @Test
    public void shouldCreateNewCustomer() throws Exception {
        // given

        // when
        Customer result = userService.createNewCustomer();

        // then
        assertThat(result).isEqualToComparingFieldByFieldRecursively(new Customer());
    }

    @Test
    public void shouldUpdateCustomer() throws Exception {
        // given
        Customer customer = new Customer();

        // when
        userService.updateCustomer(customer);

        // then
        ArgumentCaptor<Customer> customerArgumentCaptor = ArgumentCaptor.forClass(Customer.class);
        verify(customerDAO).saveOrUpdate(customerArgumentCaptor.capture());
        assertThat(customerArgumentCaptor.getValue()).isSameAs(customer);
    }
}