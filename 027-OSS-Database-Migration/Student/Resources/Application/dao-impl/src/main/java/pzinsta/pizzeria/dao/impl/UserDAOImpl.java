package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.UserDAO;
import pzinsta.pizzeria.model.user.User;

import javax.persistence.criteria.CriteriaQuery;
import java.util.Collection;

@Repository
public class UserDAOImpl extends GenericDAOImpl<User, Long> implements UserDAO {

    public UserDAOImpl() {
        super(User.class);
    }

    @Override
    public Collection<User> findWithinRange(int offset, int limit) {
        CriteriaQuery<User> criteriaQuery = entityManager.getCriteriaBuilder().createQuery(entityClass);
        criteriaQuery.select(criteriaQuery.from(entityClass));
        return entityManager.createQuery(criteriaQuery).setFirstResult(offset).setMaxResults(limit).getResultList();
    }
}
