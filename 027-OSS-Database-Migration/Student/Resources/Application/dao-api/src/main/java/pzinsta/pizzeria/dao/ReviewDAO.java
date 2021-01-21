package pzinsta.pizzeria.dao;

import pzinsta.pizzeria.model.order.Review;

import java.util.List;

public interface ReviewDAO extends GenericDAO<Review, Long> {
    List<Review> findWithinRange(int offset, int limit);
}
