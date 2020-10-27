package pzinsta.pizzeria.service;

import pzinsta.pizzeria.model.order.Review;

import java.util.List;

public interface ReviewService {
    List<Review> getReviews();

    List<Review> getReviews(int offset, int limit);

    long getTotalCount();
}
