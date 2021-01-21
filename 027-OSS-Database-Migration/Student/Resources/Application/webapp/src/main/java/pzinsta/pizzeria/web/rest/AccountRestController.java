package pzinsta.pizzeria.web.rest;

import com.google.common.collect.ImmutableMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import pzinsta.pizzeria.service.AccountService;
import pzinsta.pizzeria.service.dto.AccountDTO;
import pzinsta.pizzeria.service.exception.AccountNotFoundException;

import java.util.Collection;
import java.util.Map;

@RestController
@RequestMapping("/accounts")
public class AccountRestController {

    private AccountService accountService;
    private PasswordEncoder passwordEncoder;

    @Autowired
    public AccountRestController(AccountService accountService, PasswordEncoder passwordEncoder) {
        this.accountService = accountService;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping
    public Collection<AccountDTO> getAccounts() {
        return accountService.getAccounts();
    }

    @GetMapping(params = {"offset", "limit"})
    public Map<String, Object> getAccounts(@RequestParam("offset") int offset, @RequestParam("limit") int limit) {
        return ImmutableMap.of(
                "accounts", accountService.getAccounts(offset, limit),
                "totalCount", accountService.getTotalCount());
    }

    @GetMapping("/{id}")
    public AccountDTO getAccount(@PathVariable("id") Long id) {
        return accountService.getAccountById(id);
    }

    @PutMapping
    public AccountDTO updateAccount(@RequestBody AccountDTO accountDTO) {
        return accountService.updateAccount(accountDTO);
    }

    @PatchMapping("/{id}/password")
    public void updatePassword(@PathVariable("id") Long id, @RequestBody String password) {
        accountService.updatePassword(id, passwordEncoder.encode(password));
    }

    @ExceptionHandler(AccountNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleAccountNotFoundException(Exception e) {
        return e.getMessage();
    }

    public PasswordEncoder getPasswordEncoder() {
        return passwordEncoder;
    }

    public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
}
