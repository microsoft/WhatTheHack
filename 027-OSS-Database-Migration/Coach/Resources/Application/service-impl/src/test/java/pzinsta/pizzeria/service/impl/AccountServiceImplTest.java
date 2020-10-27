package pzinsta.pizzeria.service.impl;

import org.assertj.core.api.Assertions;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import pzinsta.pizzeria.dao.AccountDAO;
import pzinsta.pizzeria.model.user.Account;

import java.util.Optional;

public class AccountServiceImplTest {

    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private AccountDAO accountDAO;

    @InjectMocks
    private AccountServiceImpl accountService;

    @Test
    public void shouldGetAccountByUsernameFromDao() throws Exception {
        // given
        String username = "john.doe";
        Optional<Account> accountOptional = Optional.empty();
        Mockito.when(accountDAO.findByUsername(username)).thenReturn(accountOptional);

        // when
        Optional<Account> result = accountService.getAccountByUsername(username);

        // then
        Assertions.assertThat(result).isSameAs(accountOptional);
    }
}