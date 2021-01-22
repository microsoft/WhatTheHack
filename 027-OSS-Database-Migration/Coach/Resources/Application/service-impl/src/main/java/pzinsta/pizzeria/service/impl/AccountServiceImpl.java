package pzinsta.pizzeria.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pzinsta.pizzeria.dao.AccountDAO;
import pzinsta.pizzeria.model.user.Account;
import pzinsta.pizzeria.service.AccountService;
import pzinsta.pizzeria.service.dto.AccountDTO;
import pzinsta.pizzeria.service.exception.AccountNotFoundException;

import java.util.Collection;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class AccountServiceImpl implements AccountService {

    private AccountDAO accountDAO;

    @Autowired
    public AccountServiceImpl(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Account> getAccountByUsername(String username) {
            return accountDAO.findByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public Collection<AccountDTO> getAccounts() {
        return accountDAO.findAll().stream()
                .map(AccountServiceImpl::transformAccountToAccountDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public Collection<AccountDTO> getAccounts(int offset, int limit) {
        return accountDAO.findWithinRange(offset, limit).stream()
                .map(AccountServiceImpl::transformAccountToAccountDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public AccountDTO getAccountById(Long id) {
        return accountDAO.findById(id)
                .map(AccountServiceImpl::transformAccountToAccountDTO)
                .orElseThrow(AccountNotFoundException::new);

    }

    @Override
    @Transactional
    public AccountDTO updateAccount(AccountDTO accountDTO) {
        Account account = accountDAO.findById(accountDTO.getId()).orElseThrow(AccountNotFoundException::new);
        account.setUsername(accountDTO.getUsername());
        account.setEnabled(accountDTO.isEnabled());
        account.setCredentialsExpired(accountDTO.isCredentialsExpired());
        account.setAccountLocked(accountDTO.isAccountLocked());
        account.setAccountExpired(accountDTO.isAccountExpired());
        account.setRoles(accountDTO.getRoles());
        return transformAccountToAccountDTO(account);
    }

    @Override
    @Transactional
    public void updatePassword(Long id, String password) {
        Account account = accountDAO.findById(id).orElseThrow(AccountNotFoundException::new);
        account.setPassword(password);
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalCount() {
        return accountDAO.getCount();
    }

    private static AccountDTO transformAccountToAccountDTO(Account account) {
        AccountDTO accountDTO = new AccountDTO();
        accountDTO.setId(account.getId());
        accountDTO.setUsername(account.getUsername());
        accountDTO.setEnabled(account.isEnabled());
        accountDTO.setAccountExpired(account.isAccountExpired());
        accountDTO.setCredentialsExpired(account.isCredentialsExpired());
        accountDTO.setAccountLocked(account.isAccountLocked());
        accountDTO.setCreatedOn(account.getCreatedOn());
        accountDTO.setRoles(account.getRoles());
        accountDTO.setUserId(account.getUser().getId());
        return accountDTO;
    }

}
