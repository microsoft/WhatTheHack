package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.OrderDAO;
import pzinsta.pizzeria.model.order.Order;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.Optional;

@Repository
public class OrderDAOImpl extends GenericDAOImpl<Order, Long> implements OrderDAO {
    public OrderDAOImpl() {
        super(Order.class);
    }

    @Override
    public Optional<Order> findByTrackingNumber(String trackingNumber) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Order> criteriaQuery = criteriaBuilder.createQuery(entityClass);
        Root<Order> root = criteriaQuery.from(entityClass);
        criteriaQuery.select(root);
        criteriaQuery.where(criteriaBuilder.equal(root.get("trackingNumber"), trackingNumber));
        TypedQuery<Order> typedQuery = entityManager.createQuery(criteriaQuery);
        return typedQuery.getResultList().stream().findFirst();
    }
}
