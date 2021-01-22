package pzinsta.pizzeria.service.impl;

import com.google.common.collect.ImmutableList;
import org.assertj.core.api.Assertions;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import pzinsta.pizzeria.dao.OrderItemTemplateDAO;
import pzinsta.pizzeria.model.order.OrderItemTemplate;

import java.util.Collection;

public class OrderItemTemplateServiceImplTest {

    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private OrderItemTemplateDAO orderItemTemplateDAO;

    @InjectMocks
    private OrderItemTemplateServiceImpl orderItemTemplateService;

    @Test
    public void shouldGetOrderItemTemplates() throws Exception {
        // given
        ImmutableList<OrderItemTemplate> orderItemTemplates = ImmutableList.of();
        Mockito.when(orderItemTemplateDAO.findAll()).thenReturn(orderItemTemplates);

        // when
        Collection<OrderItemTemplate> result = orderItemTemplateService.getOrderItemTemplates();

        // then
        Assertions.assertThat(result).isSameAs(orderItemTemplates);
    }
}