package pzinsta.pizzeria.service.impl;

import com.google.common.collect.ImmutableList;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import pzinsta.pizzeria.dao.ReviewDAO;
import pzinsta.pizzeria.model.order.Review;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

public class ReviewServiceImplTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private ReviewDAO reviewDAO;

    @InjectMocks
    private ReviewServiceImpl reviewService;

    @Test
    public void shouldGetReviews() throws Exception {
        // given
        ImmutableList<Review> reviews = ImmutableList.of();
        Mockito.when(reviewDAO.findAll()).thenReturn(reviews);

        // when
        List<Review> result = reviewService.getReviews();

        // then
        assertThat(result).isSameAs(reviews);
    }
}