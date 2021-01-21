package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.ReviewDAO;
import pzinsta.pizzeria.model.order.Review;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.List;

@Repository
public class ReviewDAOImpl extends GenericDAOImpl<Review, Long> implements ReviewDAO {

    public ReviewDAOImpl() {
        super(Review.class);
    }

    @Override
    public List<Review> findWithinRange(int offset, int limit) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Review> criteriaQuery = criteriaBuilder.createQuery(entityClass);
        Root<Review> reviewRoot = criteriaQuery.from(entityClass);
        criteriaQuery.select(reviewRoot);
        criteriaQuery.orderBy(criteriaBuilder.desc(reviewRoot.get("createdOn")));
        return entityManager.createQuery(criteriaQuery).setFirstResult(offset).setMaxResults(limit).getResultList();
    }
}
