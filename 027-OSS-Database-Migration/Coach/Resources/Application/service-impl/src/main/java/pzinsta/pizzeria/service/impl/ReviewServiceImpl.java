package pzinsta.pizzeria.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pzinsta.pizzeria.dao.ReviewDAO;
import pzinsta.pizzeria.model.order.Review;
import pzinsta.pizzeria.service.ReviewService;

import java.util.List;

@Service
public class ReviewServiceImpl implements ReviewService {

    private ReviewDAO reviewDAO;

    @Autowired
    public ReviewServiceImpl(ReviewDAO reviewDAO) {
        this.reviewDAO = reviewDAO;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Review> getReviews() {
        return reviewDAO.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Review> getReviews(int offset, int limit) {
        return reviewDAO.findWithinRange(offset, limit);
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalCount() {
        return reviewDAO.getCount();
    }
}
