package pzinsta.pizzeria.web.security.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pzinsta.pizzeria.model.user.Account;
import pzinsta.pizzeria.service.AccountService;

import java.util.Optional;

@Service
public class PizzeriaUserDetailsService implements UserDetailsService {

    private AccountService accountService;

    @Autowired
    public PizzeriaUserDetailsService(AccountService accountService) {
        this.accountService = accountService;
    }

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) {
        Optional<Account> accountOptional = accountService.getAccountByUsername(username);
        Account account = accountOptional.orElseThrow(() -> new UsernameNotFoundException("Username not found."));
        return User.builder()
                .username(account.getUsername())
                .password(account.getPassword())
                .accountExpired(account.isAccountExpired())
                .accountLocked(account.isAccountLocked())
                .credentialsExpired(account.isCredentialsExpired())
                .disabled(!account.isEnabled())
                .roles(account.getRoles().stream().map(Enum::toString).toArray(String[]::new)).build();
    }

}
