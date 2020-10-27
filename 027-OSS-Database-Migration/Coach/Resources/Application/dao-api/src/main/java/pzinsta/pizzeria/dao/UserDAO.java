package pzinsta.pizzeria.dao;

import pzinsta.pizzeria.model.user.User;

import java.util.Collection;

public interface UserDAO extends GenericDAO<User, Long> {
    Collection<User> findWithinRange(int offset, int limit);
}
