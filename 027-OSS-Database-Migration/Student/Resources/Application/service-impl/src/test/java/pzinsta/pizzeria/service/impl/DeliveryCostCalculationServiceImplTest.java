package pzinsta.pizzeria.service.impl;

import org.assertj.core.api.Assertions;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import pzinsta.pizzeria.model.delivery.Delivery;
import pzinsta.pizzeria.service.impl.strategy.DeliveryCostCalculationStrategy;

import javax.money.Monetary;
import javax.money.MonetaryAmount;

public class DeliveryCostCalculationServiceImplTest {

    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private DeliveryCostCalculationStrategy deliveryCostCalculationStrategy;

    @InjectMocks
    private DeliveryCostCalculationServiceImpl deliveryCostCalculationService;

    @Test
    public void shouldCalculateCost() throws Exception {
        // given
        Delivery delivery = new Delivery();
        MonetaryAmount cost = Monetary.getDefaultAmountFactory().setNumber(9.99).setCurrency("USD").create();
        Mockito.when(deliveryCostCalculationStrategy.calculateCost(delivery)).thenReturn(cost);

        // when
        MonetaryAmount result = deliveryCostCalculationService.calculateCost(delivery);

        // then
        Assertions.assertThat(result).isEqualTo(cost);
    }
}