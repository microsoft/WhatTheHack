package pzinsta.pizzeria.dao;

import pzinsta.pizzeria.model.user.Account;

import java.util.Collection;
import java.util.Optional;

public interface AccountDAO extends GenericDAO<Account, Long> {
    Optional<Account> findByUsername(String username);

    Collection<Account> findWithinRange(int offset, int limit);
}
