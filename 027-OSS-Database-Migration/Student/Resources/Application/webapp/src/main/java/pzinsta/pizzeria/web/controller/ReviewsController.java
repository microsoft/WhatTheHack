package pzinsta.pizzeria.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import pzinsta.pizzeria.service.ReviewService;

@Controller
@RequestMapping("/reviews")
public class ReviewsController {

    private ReviewService reviewService;

    @Value("${reviews.per.page}")
    private int reviewsPerPage;

    @Autowired
    public ReviewsController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @GetMapping
    public String showReviews(Model model) {
        return showReviewsForPage(1, model);
    }

    @GetMapping("/{pageNumber}")
    public String showReviewsForPage(@PathVariable("pageNumber") int pageNumber, Model model) {
        int offset = (pageNumber - 1) * reviewsPerPage;
        model.addAttribute("currentPageNumber", pageNumber);
        model.addAttribute("totalPagesCount", Math.ceil(reviewService.getTotalCount() / reviewsPerPage));
        model.addAttribute("reviews", reviewService.getReviews(offset, reviewsPerPage));
        return "reviews";
    }

    public ReviewService getReviewService() {
        return reviewService;
    }

    public void setReviewService(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    public int getReviewsPerPage() {
        return reviewsPerPage;
    }

    public void setReviewsPerPage(int reviewsPerPage) {
        this.reviewsPerPage = reviewsPerPage;
    }
}
