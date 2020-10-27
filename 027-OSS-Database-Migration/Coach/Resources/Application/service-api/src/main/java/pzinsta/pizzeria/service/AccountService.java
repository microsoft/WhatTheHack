package pzinsta.pizzeria.service;

import pzinsta.pizzeria.model.user.Account;
import pzinsta.pizzeria.service.dto.AccountDTO;

import java.util.Collection;
import java.util.Optional;

public interface AccountService {

    Optional<Account> getAccountByUsername(String username);

    Collection<AccountDTO> getAccounts();

    Collection<AccountDTO> getAccounts(int offset, int limit);

    AccountDTO getAccountById(Long id);

    AccountDTO updateAccount(AccountDTO accountDTO);

    void updatePassword(Long id, String password);

    long getTotalCount();
}
